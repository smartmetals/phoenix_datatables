import $ from 'jquery';
import dt from 'datatables.net';

export default function() {
  $(document).ready(() => {
    dt();

    $('[data-datatable-server]').dataTable({
      lengthChange: false,
      serverSide: true,
      ajax: 'datatables/items',
      columns: [
        { data: "nsn" },
        { data: "category.name" },
        { data: "common_name" },
        { data: "description" },
        { data: "price" },
        { data: "unit.description" },
        { data: "aac" },
      ]
    });
  })
}
