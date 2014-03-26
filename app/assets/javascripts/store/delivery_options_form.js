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
           that.showSuccessMessage();
         });
     });
  };

  this.showSuccessMessage = function() {
    $('#delivery-options-homepage .form').hide();
    $('#delivery-options-homepage .success').show();
  };

}

$(document).ready(function() {
  var deliveryOptionsForm = new SpreeDeliveryOptionsForm();
  deliveryOptionsForm.initializeForm();
});
