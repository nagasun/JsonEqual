/*
compare two json string, check equal
dbo.JsonEqual('{"id":  "abc"}', '{"id":"abc"}');	//1 ignore space
dbo.JsonEqual('{"Id":"abc"}', '{"id":"abc"}');		//0 case sensitive
dbo.JsonEqual('{"id":123,"name":"Charlie"}', '{"name":"Charlie","id":123}');	//0 ignore properties order
*/
CREATE FUNCTION JsonEqual
(
	@a nvarchar(max),
	@b nvarchar(max)
)
RETURNS bit
AS
BEGIN


set @a = NullIf(@a, '');
set @b = NullIf(@b, '');

if (@a is null and @b is null or @a = @b COLLATE Chinese_PRC_CS_AS)
	return 1;

if (IsJson(@a) = 0 or IsJson(@b) = 0)
	return 0;

declare @list table([key] nvarchar(500), valueA nvarchar(max), valueB nvarchar(max), typeA int, typeB int, deep int);

declare @deep int = 1;

insert into @list([key], valueA, typeA, deep)
select [key], [value], [type], @deep from openjson(@a);

merge into @list as T
using (select [key], [value], [type] from openjson(@b)) as R on R.[key] = T.[key] COLLATE Chinese_PRC_CS_AS
when matched then update set valueB = R.[value], typeB = R.[type]
when not matched then insert([key], valueB, typeB, deep)values(R.[key], R.[value], R.[type], @deep);

while (exists(select 1 from @list))
begin
	if exists(select 1 from @list where typeA is null or typeB is null or typeA != typeB or typeA in (1,2,3) and valueA COLLATE Chinese_PRC_CS_AS != valueB)
		return 0;

	delete @list where typeA in (1, 2, 3);

	--fetch items form obj A
	insert into @list([key], valueA, typeA, deep)
	select IIF(P.typeA = 4, concat(P.[key], '[', C.[key], ']'), concat(P.[key], '.', C.[key])), C.value, C.type, @deep + 1
	from @list P
	cross apply openjson(P.[valueA]) C;

	merge into @list as T
	using
	(
		select IIF(P.typeA = 4, concat(P.[key], '[', C.[key], ']'), concat(P.[key], '.', C.[key])) as [key], C.value, C.type 
		from @list P
		cross apply openjson(P.[valueB]) C
		where P.[deep] = @deep
	) as R on R.[key] = T.[key] COLLATE Chinese_PRC_CS_AS and T.deep = @deep + 1
	when matched then update set valueB = R.value, typeB = R.type
	when not matched then insert([key], valueB, typeB, deep)values(R.[key], R.value, R.type, @deep + 1);

	delete @list where deep = @deep;
	set @deep += 1;
end;


return 1;

END