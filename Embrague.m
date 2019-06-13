classdef Embrague < handle
    properties
        pedal
    end
    methods
        function E = Embrague()
            E.pedal = 0;
        end
        
        function set.pedal(E, pedal)
            [dim1, dim2] = size(pedal);
            if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(pedal)
                error('Pedal debe ser un número.');
            elseif pedal < 0 || pedal > 1
                error('Pedal debe ser un número entre 0 y 1.');
            else
                E.pedal = pedal;
            end
        end
        
        function n = actua(E,n_input)
            if E.pedal <= 0.1
                n = n_input;
            elseif E.pedal >= 0.9
                n = 0;
            else
                n = ( (1 - erf(6.25 * E.pedal - 3.125) ) / 2 ) * n_input;
            end
                    
        end
        
    end
end