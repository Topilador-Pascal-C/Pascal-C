program testeProgram;

var
	variavel_String : string;
	variavel_Char   : char;
	_variavelBool   : boolean;

	variavelShortint : shortint;
	variavelSmallint : smallint;
	variavelLongint_ : longint;
	variavel_Int64   : int64;
	variavelByte     : byte;
	VariavelWord     : word;
	variavelLongword : longword;
	variavelqword    : qword;

	variavelCardinal : cardinal;
	variavelInteger  : integer;
	
	variavelSingle   : single;
	variavelSingle   : single;
	variavelDouble   : double;
	variavelExtended : extended;

begin
	if variavelShortint = 10 then
		if variavelShortint = variavelDouble then
		begin
			variavel_String := 'isso';
		end;

	if variavelShortint = variavelDouble then
		variavelExtended := 785.58;

	for variavelInteger := 0 to 115 do
		if _variavelBool then
		begin
			variavelDouble := 3.5;
		end;

	for variavelInteger := 115 downto 0 do
	begin
		if _variavelBool then
			variavel_String := 'top';

		variavel_String := 'tomaaaa';
	end;

	for variavelInteger := 0 to variavelDouble do
	begin
		variavel_String := 'Maria';
		if _variavelBool then begin variavel_String := 'oi'; end;
	end;

	while 7.5 = variavelDouble do
	begin
		if _variavelBool = variavelqword or variavel_String < variavel_Char then
			variavelDouble := 78419.1578;
	end;

	while variavelShortint <> 10 do
		variavel_String := 'show';

	repeat
		while variavelShortint <= variavelDouble do
		begin
			while variavelShortint >= variavelDouble do
			begin
				variavelDouble := 748.01;
			end;
		end;
	until variavelInteger > 0;


	read(variavelInteger);
	readln(variavelInteger);

	writeln('Somemessage');
	write('Oxi');
	writeln('kkkk hahahaha');
	writeln(895);
	write(7.84);
	
	variavelInteger := 2 + 3 - 8 * 10;
	variavelInteger := 100 div 10;
	variavelDouble := 100.50 / 10.0;
	variavelInteger := 100 / 10.0;

	variavelInteger := 4 mod 2;
	variavelInteger := 4 mod 3;

	//comentario de teste
	// comentarioumapalavra

	{comentario de uma linha sem asterisco}
	{* comentario de uma linha com asterisco *}

end.
