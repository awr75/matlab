function zadig
% Installation des USB-Treibers fuer RTL-SDR-kompatible USB-Empfaenger unter
% Microsoft Windows mit Hilfe des Programms zadig (http://zadig.akeo.ie/).
%
% Stand 07/2017:
% Das Programm zadig ist in den Beispielen in der Version 2.3 enthalten und
% kann mit der Funktion zadig.m aufgerufen werden. Bei Problemen pruefen Sie
% bitte, ob eine neuere Version verfuegbar ist.

sys_id = check_system;
if sys_id > 4
    print_flush('Diese Funktion wird nur unter Microsoft Windows benoetigt.\n');
else
    print_flush('Aufruf von zadig-2.3.exe ... ');
    [stat,msg] = system('zadig-2.3.exe');
    if stat ~= 0
        fprintf(1,'\nFehler: %s\n',msg);
    else
        fprintf(1,'OK\n');
    end
end
