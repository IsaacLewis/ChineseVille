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

function tickClock(timer, maxSecs, clockId, metricId, metric) {
    document.getElementById(metricId).innerHTML = metric;
    document.getElementById(clockId).innerHTML = intToTime(timer);
    timer--;
    if(timer < 0) {
	timer = maxSecs;
	metric++;
    }
    setTimeout("tickClock("+timer+","+maxSecs+",'"+clockId+"','"+metricId+"',"+metric+")",1000);
}

function showFood() {
  if (Element.empty('food-info')) {
    document.getElementById('food-info').innerHTML = 'Production: <%= @village.food_production %> from <%= @user.learned_words %> learned words<br />Consumption: <%= @village.food_consumption %>';
  } else {
    document.getElementById('food-info').innerHTML = '';
  }
}

