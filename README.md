<<<<<<< HEAD
compare two json string, check equal
dbo.JsonEqual('{"id":  "abc"}', '{"id":"abc"}');	//1
dbo.JsonEqual('{"Id":"abc"}', '{"id":"abc"}');		//0
dbo.JsonEqual('{"id":123,"name":"Charlie"}', '{"name":"Charlie","id":123}');	//0
=======
# JsonEqual
SQL SERVER JSON Equal compare

compare two json string, check equal
dbo.JsonEqual('{"id":  "abc"}', '{"id":"abc"}');	//1
dbo.JsonEqual('{"Id":"abc"}', '{"id":"abc"}');		//0
dbo.JsonEqual('{"id":123,"name":"Charlie"}', '{"name":"Charlie","id":123}');	//0
>>>>>>> origin/master
