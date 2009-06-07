require("/javascripts/foo");

var FakeAjax = new Object();
$.ajax = FakeAjax;
