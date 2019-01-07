import $ from 'jquery';
import dt from 'datatables.net';

export default function() {
  $(document).ready(() => {
    $('[data-datatable-server]').dataTable({
      lengthChange: false,
      serverSide: true,
      ajax: 'datatables/items',
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
  })
}
