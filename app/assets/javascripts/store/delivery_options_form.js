function SpreeDeliveryOptionsForm() {

  var that = this;

  this.initializeForm = function() {
     var formUrl = $('#delivery-options-form').attr('action');

     $("#delivery-options-form input[type='submit']").click(function(event){
       event.preventDefault();

       var formData = $('#delivery-options-form').serialize();
       $.post(
         formUrl,
         formData,
         function(data) {
           if (data.delivery_date !== null) {
             that.showSuccessMessage();
           } else {
             that.showErrorMessage("Please enter a valid date.");
           }
         }).fail(function(data){
           if (data.responseJSON.errors.delivery_date !== undefined) {
             that.showErrorMessage(data.responseJSON.errors.delivery_date[0]);
           } else if (data.responseJSON.errors.delivery_time !== undefined) {
             that.showErrorMessage(data.responseJSON.errors.delivery_time[0]);
           } else {
             that.showErrorMessage("We could not update the delivery date. Please try at checkout.");
           }
         });
     });
  };

  this.showSuccessMessage = function() {
    $('#delivery-options-homepage .form').hide();
    $('#delivery-options-homepage .success').show();
  };

  this.showErrorMessage = function(message) {
    $('#delivery-options-homepage .error').html("<h5>" + message + "</h5>");
    $('#delivery-options-homepage .error').show();
  };

}

$(document).ready(function() {
  var deliveryOptionsForm = new SpreeDeliveryOptionsForm();
  deliveryOptionsForm.initializeForm();
});
