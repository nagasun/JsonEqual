# JsonEqual
SQL SERVER JSON Equal compare

compare two json string, check equal

```sql

--ignore useless space / 忽略无用的空格换行等
dbo.JsonEqual('{"id":  "abc"}', '{"id":"abc"}');	--1

--case sensitive / 大小写敏感
dbo.JsonEqual('{"Id":"abc"}', '{"id":"abc"}');		--0

--ignore properties order / 忽略属性顺序的影响
dbo.JsonEqual('{"id":123,"name":"Charlie"}', '{"name":"Charlie","id":123}');	--0

--ignore useless zero number / 忽略数字中无用的零
dbo.JsonEqual('{"amt": 12}', '{"amt": 12.00}');    --1
```
