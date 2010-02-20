// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function intToTime(totalSeconds) { 
    secs = totalSeconds % 60;
    totalMinutes = (totalSeconds - secs) / 60;
    mins = totalMinutes % 60;
    if (totalMinutes < 60) {
	return addZero(mins) + ":" + addZero(secs);
    }
    hours = (totalMinutes - mins) / 60;
    return hours + ":" + addZero(mins) + ":" + addZero(secs);
}

function addZero(int) {
    if(int.toString().length == 1) {
	return "0" + int;
    } else {
	return int.toString();
    }
}

function tickClock(timer, maxSecs, clockId, metricId, step, limit) {
    document.getElementById(clockId).innerHTML = intToTime(timer);
    timer--;
    if(timer < 0) {
	timer = maxSecs;
	metricEl = document.getElementById(metricId);
	metric = parseInt(metricEl.innerHTML);
	newValue = metric + step;
	if((step < 0 && newValue < limit) || (step > 0 && newValue > limit)) {
	    newValue = limit;
	}
	metricEl.innerHTML = newValue;
    }
    setTimeout("tickClock("+timer+","+maxSecs+",'"+clockId+"','"+metricId+"',"+step+","+limit+")",1000);
}

function showFood() {
  if (Element.empty('food-info')) {
    document.getElementById('food-info').innerHTML = 'Production: <%= @village.food_production %> from <%= @user.learned_words %> learned words<br />Consumption: <%= @village.food_consumption %>';
  } else {
    document.getElementById('food-info').innerHTML = '';
  }
}


function fadeButtons(excludeId) {
  $('.game_button[id!='+excludeId+']').animate({opacity: 0.5}, 500);
}

jQuery.ajaxSetup({
    'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "text/javascript")
    }
})

