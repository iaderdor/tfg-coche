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
        
        % reltrans hace referencia a la relación de transmisión. Los
        % valores han de introducirse como en un vector fila, siendo el primer
        % valor el de la marcha atrás, el segundo el de la primera marcha y
        % así sucesivamente. Todos los números han de ser positivos.
        function set.reltrans(CC,reltrans)
            [dim1, dim2] = size(reltrans);
            
            if dim1 ~= 1
                error('La relación de transmisión ha de introducirse en un vector fila');
            elseif dim2 <2
                error('Deben introducirse al menos dos relaciones de transmisión apra marchas');
            else
               for idx=1:dim2
                   if ~isnumeric(reltrans(idx))
                       error('Las relaciones de transmisión han de ser un número');
                   elseif reltrans(idx) < 0
                       error('Las relaciones de transmisión han de ser mayores que cero, incluído para la marcha atrás');
                   end
               end
               CC.reltrans = [-reltrans(1), 0, reltrans(2:dim2)];
               CC.nummarchas = dim2 - 1;
            end
        end
        
        % La eficiencia es la pérdida de torque que se produce en la caja
        % de cambios. Ha de ser un número entre 1 y 0.
        function set.eficiencia(CC,eficiencia)
            [dim1, dim2] = size(eficiencia);
            if dim1 ~= 1 && dim2 ~= 1
                error('La eficiencia ha de ser un único número');
            elseif ~isnumeric(eficiencia)
                error('La eficiencia ha de ser un valor numérico');
            elseif eficiencia <= 0 || eficiencia >1 
                error('La eficiencia tiene que tener un valor mayor que 0 y menor o igual a 1.');
            else
                CC.eficiencia = eficiencia;
            end
        end
        
        % Este es la marcha engranada actualmente. -1 hace referencia a la
        % marcha atrás, 0 al punto muerto y 1 al número de marchas que
        % tenga. Ha de ser un número entero int8, int16...
        function set.marchaactual(CC,marchaactual)
            [dim1, dim2] = size(marchaactual);
            if dim1 ~= 1 || dim2 ~= 1
                error('La marcha actual ha de ser un número entero.');
            elseif ~isinteger(marchaactual)
                error('La marcha actual ha de ser un número entero int(n).');
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
            n = n_input * CC.reltrans(CC.marchaactual + 2); % Para que se corresponda la marcha actual con la posición que tiene en el array.
            torque = torque_input * CC.eficiencia * sign(n);
        end
    end
end
