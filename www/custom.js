// Smooth fade-in for body content
$(document).ready(function() {
  $(".content-wrapper").css("opacity", 0).animate({opacity: 1}, 300);
});

// Highlight clicked cards
$(document).on("click", ".card", function() {
  $(this).addClass("card-clicked");
  setTimeout(() => $(this).removeClass("card-clicked"), 200);
});
