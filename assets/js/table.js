import $ from 'jquery';
import dt from 'datatables.net';

export default function() {
  dt();
  $('[data-datatable]').dataTable({
    lengthChange: false,
  });
}
