function main(){
	gridColor = "black";

	for(x = 0; x < 16; x++){
		$('body').append('<div class=\'row\'></div>');
	}
	for(y = 0; y < 16; y++){
		$('.row').append('<div class=\'grid\'></div>');
	}

	// Give the new grid a visible border via the css class, bordered
	$('div.grid').addClass('bordered');

	// Load the hover function after the dom elements are inserted. If this function
	// was called before the grid creation, it wouldn't work because the elements
	// wouldn't yet exist.
	colorIt();
}

// Fill in the hovered over square with the selected color
// Note the syntax for css when manipulating multiple styles. Because
// background-color isn't surrounded with quotes, you drop the - and capitalize
// the second word.
// Also, using the jQuery css function to color the squares because of the user
// defined color capability. Wouldn't be able to do this by adding a static css
// class like we did when initializing the grid
function colorIt(){
	$('div.grid').mouseenter(function(){
		var curOp = Number($(this).css('opacity'));
		curOp+= .1;
		$(this).css({
			backgroundColor: gridColor, 
			border: '1px solid ' + gridColor,
			opacity: curOp
		});
	});
}


$('button#clear').click(function(){
	var newSize = Math.min(150, prompt("Enter number of squares per side for new grid"));
	newGrid(newSize);
});

// Check the value of the selected radio input named color
$('.rdio').change(function(){
	gridColor = $('input[name=color]:checked').val();
});


// Delete the existing grid and insert a new grid based on user size, max 150 squares
function newGrid(squares){
	$('.row').remove();

	for(x = 0; x < squares; x++){
		$('body').append('<div class=\'row\'></div>');
	}
	for(y = 0; y < squares; y++){
		$('.row').append('<div class=\'grid\'></div>');
	}

	// Insert new grid based on user input. Grid fits into same 960px width.
	// width / height take an integer(?), so round to whole number.
	$('div.grid').css({
		display: 'inline-block',
		width: Math.round(960 / squares),
		height: Math.round(960 / squares),
		border: '1px solid black',
		opacity: .1
	});

	// Necessary to call the hover function again because the dom elements were
	// removed and reinserted.
	colorIt();
}

$(document).ready(main);
