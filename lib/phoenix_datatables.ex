defmodule PhoenixDatatables do
  @moduledoc """
  Phoenix Datatables provides support to quickly build an implementation
  of the [DataTables](https://datatables.net/) server-side API in your [Phoenix Framework](http://phoenixframework.org/) application.

  A full solution would typically use or include the following components:

  * A repository helper function to execute queries with client params
  * An Ecto query (Schema or other queryable object)
  * A Context module function which takes the request parameters from the
  browser and invokes the repository helper along with the query to fetch the results
  and build a response structure
  * A controller module and approprate route entries which will
  receive the `json` API requests from the browser.
  *  A view function to format the JSON data according to the requirements of the client.
  *  HTML and Javascript on the client configured per the Datatables library requirements.

  The below example is one way to compose your application but there are others; while
  most needs can probably be met just using the `Repo.fetch_datatable` function,
  public functions are documented which can be used to retain more control in your application.

  ## Repository
  You can optionally `use` `PhoenixDatatables.Repo`. This creates a helper function
  `Repo.fetch_datatable`.

      defmodule PhoenixDatatablesExample.Repo do
        use Ecto.Repo, otp_app: :phoenix_datatables_example
        use PhoenixDatatables.Repo
      end

  ## Context

  It is recommended to follow Phoenix 1.3 conventions and place the query and repository
  invocations in a function in an application context module.

      def PhoenixDatatablesExample.Stock do
        import Ecto.Query, warn: false
        alias PhoenixDatatablesExample.Repo
        alias PhoenixDatatablesExample.Stock.Item

        def items_datatable(params) do
          Repo.fetch_datatable(Item, params)
        end
      end

  ## Controller

  The controller is just like any other Phoenix json controller - the raw params request
  just needs to be passed to the datatables function and the output returned
  to the view. Typically the routing entry would setup under the :api scope.

      defmodule PhoenixDatatablesExampleWeb.ItemTableController do
        use PhoenixDatatablesExampleWeb, :controller
        alias PhoenixDatatablesExample.Stock

        action_fallback PhoenixDatatablesExampleWeb.FallbackController

        def index(conn, params) do
          render(conn, :index, payload: Stock.items_datatable(params))
        end
      end

      #router.ex

      scope "/api", PhoenixDatatablesExampleWeb do
        pipe_through :api

        get "/items", ItemTableController, :index
      end

  ## Client

  The client uses jQuery and datatables.net packages; those need to be in your `package.json`.

  A very basic client implementation might look something like the below - what is most important
  is that `serverSide: true` is set and the `ajax: ` option is set to the correct route based on your entry in `router.ex`.

  There are many, many options that can be set and various hooks into the request/response lifecycle
  that can be used to customize rendering and enable various features - please refer to the
  excellent manual, references and community content available throught the DataTables
  [website](https://datatables.net/manual/server-side).

    `index.html.eex`

    ```html
    <table data-datatable-server class="table">
      <thead>
        <tr>
          <th>Nsn</th>
          <th>Rep office</th>
          <th>Common name</th>
          <th>Description</th>
          <th>Price</th>
          <th>Ui</th>
          <th>Aac</th>
        </tr>
      </thead>
    </table>
    ```

  ```javascript
  import $ from 'jquery';
  import dt from 'datatables.net';

  $(document).ready(() => {
    dt();
    $('[data-datatable-server]').dataTable({
      serverSide: true,
      ajax: 'api/items',
      columns: [
        { data: "nsn" },
        { data: "rep_office" },
        { data: "common_name" },
        { data: "description" },
        { data: "price" },
        { data: "ui" },
        { data: "aac" }
      ]
    };
  };
  ```
  """

  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.Response
  alias PhoenixDatatables.Response.Payload
  alias Plug.Conn

  @doc """
    Prepare and execute a provided query, modified based on the params map. with the results returned in a `Payload` which
    can be encoded to json by Phoenix / Poison and consumed by the DataTables client.

    `columns` may be passed - but are optional. If columns are not provided, the list of
    valid columns to use for filtering and ordering is determined by introspection of the
    Ecto query, and the attributes and associations defined in the Schema's used in that
    query. This will not always work - Ecto queries may contain subqueries or schema-less queries.

    A list of valid columns that are eligibile to be used for sorting and filtering can be passed in
    a nested keyword list, where the first keyword is the table name, and second is
    the column name and query binding order.

    For example, suppose you have an items table that you join to a category table
    to include the category name in your datatable. Your ecto query may look like:

      query =
        (from item in Item,
        join: category in assoc(item, :category),
        select: %{id: item.id, item.nsn, category_name: category.name})

    This query can be interpreted automatically just fine as it is based on schemas and associations.
    However there is another reason to specify `columns`. The client will provide columns
    to use to filter and search in its request, but client input cannot be trusted. A denial of service
    attack could be constructed by requesting search against un-indexed fields on a large table for example.
    To harden your server you could limit the on the server-side the sorting and filtering possiblities
    by specifying the columns that should be available.

    To limit order/where clauses to include only the NSN and category name, you could pass a `columns`
    argument as `[nsn: 0, category: [name: 1]]`. Here the 0 means the nsn column belongs to the `from` table,
    and there is a `category.name` field, which is the first join table in the query. In the client configuration,
    the column :data attribute should be set to `nsn` for the first column and `category.name` for the second.
  """
  @spec execute(Ecto.Queryable.t, Conn.params, Ecto.Repo.t, Keyword.t | nil) :: Payload.t
  def execute(query, params, repo, options \\ []) do
    params = Request.receive(params)
    total_entries = Query.total_entries(query, repo)
    filtered_query =
      params
      |> Query.sort(query, options[:columns])
      |> Query.search(params, options)
      |> Query.paginate(params)

    filtered_entries = Query.total_entries(filtered_query, repo)

    filtered_query
    |> repo.all()
    |> Response.new(params.draw, total_entries, filtered_entries)
  end

  @doc """
  Use the provided function to transform the records embeded in the
  Payload, often used in a json view for example
  to convert an Ecto schema to a plain map so it can be serialized by Poison.


     query
     |> Repo.fetch_datatable(params)
     |> PhoenixDatatables.map_payload(fn item -> %{
          nsn: item.nsn,
          category_name: item.category.name}
        end)
"""
  @spec map_payload(Payload.t, (any -> any)) :: Payload.t
  def map_payload(%Payload{} = payload, fun) when is_function(fun) do
    %Payload { payload |
      data: Enum.map(payload.data, fun)
    }
  end
end
