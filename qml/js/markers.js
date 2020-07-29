function add(coord, icon) {
	var marker = markerComponent.createObject(map, {"coordinate": coord, "sourceItem.source": icon});
	map.addMapItem(marker);
}

function delete_one() {
}

function delete_all() {
	map.clearMapItems();
}
