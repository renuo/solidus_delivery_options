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
    var deliveryTimeGroups = $.parseJSON($('.delivery-time-options').attr("data"));

    if (deliveryTimeGroups){

      var timeNow = moment().format('H:mm');
      var deliveryTimeOptions;
      $.each(deliveryTimeGroups[0], function(index, value) {
        if (moment().format("H:mm") < index)
          {
            deliveryTimeOptions = value;
            return false;
          }
      });

      if (deliveryTimeOptions) {
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
    }
  };

  this.populate_delivery_time = function(options) {
    if (options && options.length > 0) {
      var selected_delivery_time = $('.selected-delivery-time').attr("data");
      var arLen = options.length;
      var newList = "";
      for ( var i=0, len=arLen; i<len; ++i ){
        if (options[i] == selected_delivery_time) {
          newList = newList + '<option selected=true value="' + options[i] + '">' + options[i]+'</option>';
        } else {
          newList = newList + "<option value='" + options[i] + "'>" + options[i]+'</option>';
        }
      }
      $('#order_delivery_time').html(newList);
    } else {
      $('#order_delivery_time').html("<option>Not available</option>");
    }
  };

}

$(document).ready(function() {
  var deliveryOptions = new SpreeDeliveryOptions();
  deliveryOptions.initializeDatePicker();
  deliveryOptions.initializeDeliveryTimeSelect();
});
