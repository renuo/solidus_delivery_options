function SpreeDeliveryOptions() {

  var that = this;

  this.initializeDeliveryTimeSelect = function() {
    if ($('#order_delivery_date').length > 0) {
      this.update_delivery_time_options();

      $('#order_delivery_date').change(function(event){
        that.update_delivery_time_options();
      });
    }
  };

  this.update_delivery_time_options = function() {
    var deliveryTimeOptions = $.parseJSON($('.delivery-time-options').attr("data"));

    if (deliveryTimeOptions){
      weekdays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

      var dateParts = []
      if ($('#order_delivery_date').val().indexOf('/') !== -1) {
        dateParts = $('#order_delivery_date').val().split('/')
      } else {
        dateParts = $('#order_delivery_date').val().split('-')
      }

      var deliveryDate = this.convertDateFormat(dateParts);
      var dayOptions = [];
      if (deliveryTimeOptions[deliveryDate]) {
        dayOptions = deliveryTimeOptions[deliveryDate];
      } else {
        dayIndex = new Date(dateParts[0], dateParts[1]-1, dateParts[2]).getDay();
        weekday = weekdays[dayIndex];
        dayOptions = deliveryTimeOptions[weekday];
      }
      this.populate_delivery_time(dayOptions);
    }
  };

  this.convertDateFormat = function(dateParts) {
    var day = dateParts[2];
    var month = parseInt(dateParts[1]);
    if (month < 10) {
      month = '0' + month;
    }
    var year = dateParts[0];
    return '' + day + '/' + month + '/' + year;
  };

  this.populate_delivery_time = function(options) {
    if (options) {
      var selected_delivery_time = $('.selected-delivery-time').attr("data");
      var arLen = options.length;
      var newList = "";
      for ( var i=0, len=arLen; i<len; ++i ){
        if (options[i] == selected_delivery_time) {
          newList = newList + '<option selected=true value="' + options[i] + '">' + options[i]+'</option>';
        } else {
          newList = newList + '<option value="' + options[i] + '">' + options[i]+'</option>';
        }
      }
      $('#order_delivery_time').html(newList);
    } else {
      $('#order_delivery_time').html("<option>No deliveries available on this date</option>");
    }
  };

}

$(document).ready(function() {
  var deliveryOptions = new SpreeDeliveryOptions();
  deliveryOptions.initializeDeliveryTimeSelect();
});
