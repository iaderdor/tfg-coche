classdef CajaCambios < handle
    properties (SetAccess = private)
        reltrans
        eficiencia
        nummarchas
        marchaactual
    end
    methods
        function CC = CajaCambios(reltrans,eficiencia)
            CC.reltrans = reltrans;
            CC.eficiencia = eficiencia;
            CC.marchaactual = int8(0);
        end
        
        % reltrans hace referencia a la relaci�n de transmisi�n. Los
        % valores han de introducirse como en un vector fila, siendo el primer
        % valor el de la marcha atr�s, el segundo el de la primera marcha y
        % as� sucesivamente. Todos los n�meros han de ser positivos.
        function set.reltrans(CC,reltrans)
            [dim1, dim2] = size(reltrans);
            
            if dim1 ~= 1
                error('La relaci�n de transmisi�n ha de introducirse en un vector fila');
            elseif dim2 <2
                error('Deben introducirse al menos dos relaciones de transmisi�n apra marchas');
            else
               for idx=1:dim2
                   if ~isnumeric(reltrans(idx))
                       error('Las relaciones de transmisi�n han de ser un n�mero');
                   elseif reltrans(idx) < 0
                       error('Las relaciones de transmisi�n han de ser mayores que cero, inclu�do para la marcha atr�s');
                   end
               end
               CC.reltrans = [-reltrans(1), 0, reltrans(2:dim2)];
               CC.nummarchas = dim2 - 1;
            end
        end
        
        % La eficiencia es la p�rdida de torque que se produce en la caja
        % de cambios. Ha de ser un n�mero entre 1 y 0.
        function set.eficiencia(CC,eficiencia)
            [dim1, dim2] = size(eficiencia);
            if dim1 ~= 1 && dim2 ~= 1
                error('La eficiencia ha de ser un �nico n�mero');
            elseif ~isnumeric(eficiencia)
                error('La eficiencia ha de ser un valor num�rico');
            elseif eficiencia <= 0 || eficiencia >1 
                error('La eficiencia tiene que tener un valor mayor que 0 y menor o igual a 1.');
            else
                CC.eficiencia = eficiencia;
            end
        end
        
        % Este es la marcha engranada actualmente. -1 hace referencia a la
        % marcha atr�s, 0 al punto muerto y 1 al n�mero de marchas que
        % tenga. Ha de ser un n�mero entero int8, int16...
        function set.marchaactual(CC,marchaactual)
            [dim1, dim2] = size(marchaactual);
            if dim1 ~= 1 || dim2 ~= 1
                error('La marcha actual ha de ser un n�mero entero.');
            elseif ~isinteger(marchaactual)
                error('La marcha actual ha de ser un n�mero entero int(n).');
            elseif marchaactual < -1 || marchaactual > CC.nummarchas
                error('No hay tantas marchas.');
            else
                CC.marchaactual = marchaactual;
            end
        end
        
        function cambiarMarcha(CC, marcha)
            CC.marchaactual = marcha;
        end
        
        function [n,torque] = actuar(CC, n_input,torque_input)
            n = n_input * CC.reltrans(CC.marchaactual + 2); % Para que se corresponda la marcha actual con la posici�n que tiene en el array.
            torque = torque_input * CC.eficiencia * sign(n);
        end
    end
end
