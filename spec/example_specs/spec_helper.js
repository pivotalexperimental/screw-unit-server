require("/implementations/foo");

var FakeAjax = new Object();
$.ajax = FakeAjax;
