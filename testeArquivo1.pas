program testeArquivo1;

var
	variavel_String : string;

	variavelSmallint : smallint;
	variavelInteger  : integer;

begin
	// Ex for integer variable
	variavelInteger := 7;

	// Ex for string variable
	variavel_String := 'Basic FOR with IF_ELSE';

	// Print of string variable
	writeln(variavel_String);

	for variavelSmallint := 0 to 10 do
	begin
		if variavelSmallint < variavelInteger then 
		begin
			writeln(1);
		end;
	end;

	// Print finally sentence
	writeln('Finally');

end.
