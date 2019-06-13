classdef Motor < handle
    properties
        acelerador
    end
    properties ( SetAccess = private )
        tipomotor
        maxtorque
        maxpotencia
        maxn
        minn
    end
    methods
        function M = Motor(tipomotor, maxtorque, maxpotencia, maxn, minn)
            if minn >= maxn
                error('La frecuencia mínima no puede ser mayor que la frecuencia máxima.');
            end
            if strcmpi(tipomotor,'electrico') && minn ~= 0
                error('La frecuencia mínima de un motor eléctrico es 0.');
            end
                
            M.tipomotor = tipomotor;
            M.maxtorque = maxtorque;
            M.maxpotencia = maxpotencia;
            M.maxn = maxn;
            M.minn = minn;
            M.acelerador  = 0;
        end

        function set.tipomotor(R, tipomotor)
            [dim1, dim2] = size(tipomotor);
            if dim1 ~= 1 || ~ischar(tipomotor)
                error('El tipo de motor ha de ser un string.');
            else
                switch tipomotor
                    case 'gasolina'
                        R.tipomotor = tipomotor;
                    case 'diesel'
                        R.tipomotor = tipomotor;
                    case 'electrico'
                        R.tipomotor = tipomotor;
                    otherwise
                        error('Tipo de motor no implementado.');
                end
            end
        end        
        
        function set.maxtorque(R, maxtorque)
            [dim1, dim2] = size(maxtorque);
            if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(maxtorque)
                error('El par máximo ha de ser un número.');
            elseif maxtorque < 0
                error('El par máximo debe ser mayor que 0.');
            else
                R.maxtorque = maxtorque;
            end
        end
        
        function set.maxpotencia(R, maxpotencia)
            [dim1, dim2] = size(maxpotencia);
            if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(maxpotencia)
                error('La potencia máxima ha de ser un número.');
            elseif maxpotencia < 0
                error('La potencia máxima debe ser mayor que 0.');
            else
                R.maxpotencia = maxpotencia;
            end
        end
        
        function set.maxn(R, maxn)
            [dim1, dim2] = size(maxn);
            if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(maxn)
                error('La frecuencia ha de ser un número.');
            elseif maxn < 0
                error('La frecuencia debe ser mayor que 0.');
            else
                R.maxn = maxn;
            end
        end
        
        function set.minn(R, minn)
            [dim1, dim2] = size(minn);
            if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(minn)
                error('La frecuencia ha de ser un número.');
            elseif minn < 0
                error('La frecuencia debe ser igual o mayor que 0.');
            else
                R.minn = minn;
            end
        end
        
        function set.acelerador(E, acelerador)
            [dim1, dim2] = size(acelerador);
            if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(acelerador)
                error('Acelerador debe ser un número.');
            elseif acelerador < 0 || acelerador > 1
                error('Acelerador debe ser un número entre 0 y 1.');
            else
                E.acelerador = acelerador;
            end
        end
        
        function out = torque(M, acelerador)
            out = M.maxtorque * acelerador;
        end
        
        function [n, torque, potencia] = actua(M)
            switch M.tipomotor
                case 'gasolina'
                    alfa = 0.6;
                    beta = 1.4;
                case 'diesel'
                    alfa = 0.87;
                    beta = 1.13;
                case 'electrico'
                    nbase = M.maxpotencia / M.maxtorque;
            end
            
            n = M.acelerador * M.maxn + (1 - M.acelerador) * M.minn;
            
            if strcmpi(M.tipomotor,'gasolina') || strcmpi(M.tipomotor,'diesel')
                P1 = alfa * M.maxpotencia / (M.maxn * 60 / ( 2 * pi));
                P2 = beta * M.maxpotencia / (M.maxn * 60 / ( 2 * pi))^2;
                P3 = M.maxpotencia / (M.maxn * 60 / ( 2 * pi))^3;
                potencia = P1 * (n * 60 / ( 2 * pi)) + P2 * (n * 60 / ( 2 * pi))^2 - P3 * (n * 60 / ( 2 * pi))^3;
                torque = potencia / n;
            elseif strcmpi(M.tipomotor,'electrico')
                if n == 0
                    torque = 0;
                    potencia = 0;
                elseif n > 0 && n <= nbase
                    torque = M.maxtorque;
                    potencia = M.maxtorque * n;
                elseif n > nbase
                    potencia = M.maxpotencia;
                    torque = M.maxpotencia / n;
                end
            end
            
            
        end
    end    
end
