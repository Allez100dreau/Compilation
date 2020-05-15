
goto Ltest1;
Lwhile1:
$3
Ltest1:
if ($1) goto Lwhile1;

$1
goto Ltest1;
Lfor1:
$5
$3
Ltest1:
if ($2) goto Lfor1;

goto Ltest1;
Lwhile1:
$3
Ltest1:
if ($1) goto Lwhile1;
