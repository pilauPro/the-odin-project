var sliderInit = 1;
var sliderNext = 2;
var count = $(slider).children().length;


$(document).ready(function(){

	$('#slider > img#' + sliderInit).fadeIn(300);

	startSlider();

});

// stops gallery loop to avoid interference with prev/next links

function stopLoop(){
	window.clearInterval(loop);
}

function prev(){
	newSlide = sliderNext - 1;
	showSlide(newSlide);

}

function next(){
	newSlide = sliderNext + 1;
	showSlide(newSlide);
}

function showSlide(id){
	stopLoop();
	if(id > count){
		sliderNext = 1;
	}
	else if(id === 0){
		sliderNext = count;
	}
	else{
		sliderNext = id;
	}

	$('#slider > img').fadeOut(300);
	$('#slider >img#' + sliderNext).fadeIn(300);
	startSlider();
}

// startSlider uses the sliderInit and sliderNext variables to cycle through the
// gallery pictures. Those variables correspond to the ids created for each img
// element in index.html. 
// Note that at the end of the setInterval function, the code pauses for 3000.
// This is the state of things at the time the previous or next links are clicked.
// So at this point, sliderInit is one behind sliderNext. If sliderNext is now 1, 
// sliderInit is 5 (or whatever the last id is). If sliderNext is 5, sliderInit is 4.

function startSlider(){
	loop = setInterval(function(){
		if(sliderNext === count){
			sliderNext = 1;
			sliderInit = count;
		}
		else{
			sliderInit = sliderNext;
			sliderNext = sliderNext + 1;
		}
		$('#slider > img').fadeOut(300);
		$('#slider >img#' + sliderNext).fadeIn(300);
	}, 3000)
}

$('img').hover(stopLoop, startSlider);