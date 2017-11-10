# Phoenix Datatables

  Phoenix Datatables provides support to quickly build an implementation
  of the [DataTables](https://datatables.net/) server-side API in your [Phoenix Framework](http://phoenixframework.org/) application.

  Add this to your `mix.exs` dependency list:

```elixir
{:phoenix_datatables, "~> 0.1.0"}
```

  There is a complete [example](https://github.com/smartmetals/phoenix_datatables/tree/master/example).

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

```elixir
  defmodule PhoenixDatatablesExample.Repo do
    use Ecto.Repo, otp_app: :phoenix_datatables_example
    use PhoenixDatatables.Repo
  end
```

## Context

  It is recommended to follow Phoenix 1.3 conventions and place the query and repository
  invocations in a function in an application context module.

```elixir
  def PhoenixDatatablesExample.Stock do
    import Ecto.Query, warn: false
    alias PhoenixDatatablesExample.Repo
    alias PhoenixDatatablesExample.Stock.Item

    def datatable_items(params) do
      Repo.fetch_datatable(Item, params)
    end
  end
```

## Controller

  The controller is like any other Phoenix json controller - the raw params request
  from Datatables needs to be passed to the datatables context function
  and the output sent to the view for rendering as json.
  Typically the routing entry would be setup under the :api scope.

```elixir
  defmodule PhoenixDatatablesExampleWeb.ItemTableController do
    use PhoenixDatatablesExampleWeb, :controller
    alias PhoenixDatatablesExample.Stock

    action_fallback PhoenixDatatablesExampleWeb.FallbackController

    def index(conn, params) do
      render(conn, :index, payload: Stock.datatable_items(params))
    end
  end

  #router.ex

  scope "/api", PhoenixDatatablesExampleWeb do
    pipe_through :api

    get "/items", ItemTableController, :index
  end
```

## View

  As with any Phoenix json method, a loaded Ecto schema cannot be serialized directly
  to json by `Poison`. There are two solutions: Either the Ecto query needs to use a select to return
  a plain map, e.g.


```elixir
from item in Item,
  select: %{
    nsn: item.nsn,
    rep_office: item.rep_office,
    ...
  }
```


  Or a map function is required to transform the results in the view. This is preferred if other
  transformations are also required.

```elixir
def render("index.json", %{payload: payload}) do
  PhoenixDatatables.map_payload(payload, &item_json/1)
end

def item_json(item) do
  %{
    nsn: item.nsn,
    rep_office: item.rep_office,
    common_name: item.common_name,
    description: item.description,
    price: item.price,
    ui: item.ui,
    aac: item.aac
  }
end
```

## Client

  The client uses jQuery and datatables.net packages; those need to be in your `package.json`.

  Brunch needs to be configured to include styles and images from the datatables.net NPM package.

  A very basic client implementation might look something like the below - what is most important
  is that `serverSide: true` is set and the `ajax: ` option is set to the correct route based on your entry in `router.ex`.

  There are many, many options that can be set and various hooks into the request/response lifecycle
  that can be used to customize rendering and enable various features - please refer to the
  excellent manual, references and community content available throught the DataTables
  [website](https://datatables.net/manual/server-side).

`package.json`

```json

  "dependencies": {
    "jquery": "^3.2.1",
    "datatables.net": "^1.10.15",
    "datatables.net-dt": "^1.10.15"
  },

  "devDependencies": {
    "copycat-brunch": "^1.1.0"
  }
```

`brunch-config.js`
    
```javascript

  npm: {
    enabled: true,
    styles: {
      'datatables.net-dt': [ 'css/jquery.dataTables.css' ],
    }
  }

  plugins: {
    copycat: {
      'images': [ 'node_modules/datatables.net-dt/images' ],
  },

```

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

`app.js`

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

## Joins

Ecto queryables using joins are supported with automatic introspection - meaning columns used in the DataTable will be sortable and searchable if they are specified appropriately in the client-side configuration. The `example/` project in the source repo works this way.

Assuming an Ecto queryable that looks like:

```elixir
    query =
      from item in Item,
      join: category in assoc(item, :category),
      join: unit in assoc(item, :unit),
      preload: [category: category, unit: unit]
```

And a view transformation that looks like: 

```elixir
  def item_json(item) do
    %{
      nsn: item.nsn,
      rep_office: item.rep_office,
      common_name: item.common_name,
      description: item.description,
      price: item.price,
      ui: item.ui,
      aac: item.aac,
      unit_description: item.unit.description,
      category_name: item.category.name,
    }
  end
```

Could be used with a client-side configuration that looks like:
```javascript
      columns: [
        { data: "nsn" },
        { data: "category_name", name: "category.name"},
        { data: "common_name" },
        { data: "description" },
        { data: "price" },
        { data: "unit_description", name: "unit.description" },
        { data: "aac" },
      ]
    });
```

You'll notice this differs from the basic configuration in that a `name` attribute is specified with the qualified column name. You could alternatively use the value `unit.description` in the `data` attribute and not supply a name attribute, but then the DataTables client library will expect to find a nested structure in the response message, so your view would have to nest it e.g.: 

```javascript
 columns: [
        { data: "nsn" },
        { data: "category_name", name: "category.name"},
        { data: "common_name" },
        { data: "description" },
        { data: "price" },
        unit: %{
          description: item.unit.description
        },
```

The important thing to understand is that when a `name` attribute is supplied, the server uses that to identify the field to search / sort - regardless of the value of the `data` attribute. The *client* library always uses `data` to identify the data path to map the response into the generated HTML. The client uses the `name` attribute only to make it easier to refer to columns by name in scripts using the client API.


## Credits

Libraries which provided inspiration and some code include: 

* `scrivener_ecto`: https://github.com/drewolson/scrivener_ecto

* `ex_sieve`: https://github.com/valyukov/ex_sieve
