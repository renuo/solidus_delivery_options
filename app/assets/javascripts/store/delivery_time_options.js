function SpreeDeliveryOptions() {

  var that = this;

  this.initializeDatePicker = function() {
     $('#order_delivery_date').datepicker({
       dateFormat: "dd/mm/yy",
       minDate: 1 
     });
  };

  this.initializeDeliveryTimeSelect = function() {
    this.update_delivery_time_options();

    $('#order_delivery_date').change(function(event){
      that.update_delivery_time_options();
    });
  };

  this.update_delivery_time_options = function() {
    deliveryTimeOptions = $.parseJSON($('.delivery-time-options').attr("data"));

    if (deliveryTimeOptions){
      weekdays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
      
      var dayOptions = [];
      var deliveryDate = $('#order_delivery_date').val();

      if (deliveryTimeOptions[deliveryDate]) {
        dayOptions = deliveryTimeOptions[deliveryDate];
      } else {
        var dateParts = deliveryDate.split('/')
        var dayIndex = new Date(dateParts[2], dateParts[1]-1, dateParts[0]).getDay();
        weekday = weekdays[dayIndex];

        dayOptions = deliveryTimeOptions[weekday];
      }
      this.populate_delivery_time(dayOptions);
    }
  };

  this.populate_delivery_time = function(options) {
    if (options) {
      var arLen = options.length;
      var newList = "";
      for ( var i=0, len=arLen; i<len; ++i ){
        newList = newList + '<option>' + options[i]+'</option>';
      }
      $('#order_delivery_time').html(newList);
    } else {
      $('#order_delivery_time').html("<option>No deliveries available</option>");
    }
  };

}

$(document).ready(function() {
  var deliveryOptions = new SpreeDeliveryOptions();
  deliveryOptions.initializeDatePicker();
  deliveryOptions.initializeDeliveryTimeSelect();
});
