import $ from 'jquery';
import dt from 'datatables.net';

export default function() {
  dt();
  $('[data-datatable]').dataTable({
    lengthChange: false,
  });

  $('[data-datatable-server]').dataTable({
    lengthChange: false,
    serverSide: true,
    ajax: 'api/items'
  });
}
