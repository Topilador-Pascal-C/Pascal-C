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
	variavelDouble   : double;
	variavelExtended : extended;

begin
	if variavelShortint = variavelDouble then
		if variavelShortint = variavelDouble then
		begin
			variavelExtended := 'teste';
			variavelInteger := 123;
		end;

	if variavelShortint = variavelDouble then
		variavelExtended := 'teste';

	if variavelShortint < variavelDouble then begin
		_variavelBool := 'teste';
		variavel_String := 'teste';
		if _variavelBool then begin variavel_String := 'teste'; end;
	end;

	variavelShortint := 'teste';

	variavelDouble := 3.5;


	while variavelShortint = variavelDouble do
	begin
		if _variavelBool = variavelqword or variavel_String < variavel_Char then
		begin
			variavelDouble := 'teste';
		end;
	end;


	while variavelShortint <> variavelDouble do
	begin
		variavelDouble := 'teste';
	end;


	while variavelShortint <= variavelDouble do
	begin
		while variavelShortint >= variavelDouble do
		begin
			variavelDouble := 'teste';
		end;
	end;

	for variavelShortint := variavelSmallint to variavelLongint_ do

	writeln('Somemessage');

end.
