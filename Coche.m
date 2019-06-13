classdef Coche < handle
    properties
        masa
        leje
        empate
        altura
        tinercia
        posicion3
        direccion4       % Vector 3dimensional y ángulo
        velocidad3
        motor
        embrague
        cajadecambios
        ruedas           % A efectos prácticos, consideramos todas las ruedas iguales.
        resaero
        resgrad
    end
    methods(Static)
        function out = is3dvector(vector)
           [dim1, dim2] = size(vector);
           if dim1 ~= 1 || dim2 ~= 3 || ~isnumeric(vector)
               out = false;
           else
               out = true;
           end  
        end     
        function out = rotar(vector, eje, angulo)
             if ~Coche.is3dvector(vector) || ~Coche.is3dvector(eje)
                 error('vector y eje han de ser vectores fila 3-dimensionales.');
             elseif ~isscalar(angulo) || ~isnumeric(angulo)
                 error('El angulo ha de ser un número escalar.');
             else
                 eje = eje / norm(eje);
             end
             
             K = [0, -eje(3), eje(2); eje(3), 0, -eje(1); -eje(2), eje(1), 0];
             R = eye(3) + (sin(angulo)) * K + (1 - cos(angulo)) * K^2;
             out = (R * vector')';
        end
    end
    methods
        function coche = Coche(masa, leje, empate, altura, coefaero, M, CC, radiorueda, densidadrueda)
            coche.masa = masa;
            coche.leje = leje;
            coche.empate = empate;
            coche.altura = altura;
            coche.tinercia = 1 / 12 * coche.masa * (coche.leje^2 * coche.empate^2);
            coche.posicion3 = [0, 0, 0];
            coche.direccion4 = [1, 0, 0, 0];
            coche.velocidad3 = [0, 0, 0];
            coche.motor = M;
            coche.embrague = Embrague();
            coche.cajadecambios = CC;
            coche.ruedas = Rueda(radiorueda, densidadrueda);
            coche.resaero = ResAerodinamica(coefaero, coche.altura * coche.leje, 1.225);
            coche.resgrad = ResGradiente(masa);
        end
        function set.masa(coche,masa)
           [dim1, dim2] = size(masa);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(masa)
               error('La masa ha de ser un número.');
           elseif masa < 0
               error('La masa debe ser mayor que 0.');
           else
               coche.masa = masa;
           end 
        end
        function set.leje(coche,leje)
           [dim1, dim2] = size(leje);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(leje)
               error('La longitud del eje ha de ser un número.');
           elseif leje < 0
               error('La longitud del eje debe ser mayor que 0.');
           else
               coche.leje = leje;
           end 
        end
        function set.empate(coche,empate)
           [dim1, dim2] = size(empate);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(empate)
               error('El empate ha de ser un número.');
           elseif empate < 0
               error('El empate debe ser mayor que 0.');
           else
               coche.empate = empate;
           end 
        end
        function set.altura(coche,altura)
           [dim1, dim2] = size(altura);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(altura)
               error('La altura ha de ser un número.');
           elseif altura < 0
               error('La altura debe ser mayor que 0.');
           else
               coche.altura = altura;
           end 
        end
        function set.tinercia(coche,tinercia)
           [dim1, dim2] = size(tinercia);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(tinercia)
               error('El tensor de inercia ha de ser un número.');
           elseif tinercia < 0
               error('El tensor de inercia debe ser mayor que 0.');
           else
               coche.tinercia = tinercia;
           end 
        end
        function set.posicion3(coche,posicion3)
           [dim1, dim2] = size(posicion3);
           if dim1 ~= 1 || dim2 ~= 3 || ~isnumeric(posicion3)
               error('La posición ha de ser un vector fila de dimensión 3.');
           else
               coche.posicion3 = posicion3;
           end 
        end
        function set.direccion4(coche,direccion4)
           [dim1, dim2] = size(direccion4);
           if dim1 ~= 1 || dim2 ~= 4 || ~isnumeric(direccion4)
               error('La posición ha de ser un vector fila de dimensión 4.');
           elseif norm(direccion4(1:3)) ~= 1
               coche.direccion4(1:3) = direccion4(1:3) / norm(direccion4(1:3));
               coche.direccion4(4) = direccion4(4);
           else
               coche.direccion4 = direccion4;
           end 
        end
        function set.velocidad3(coche, velocidad3)
           [dim1, dim2] = size(velocidad3);
           if dim1 ~= 1 || dim2 ~= 3 || ~isnumeric(velocidad3)
               error('La velocidad ha de ser un vector fila de dimensión 3.');
           else
               coche.velocidad3 = velocidad3;
           end
        end
        function set.motor(coche, M)
            if isa(M, 'Motor')
                coche.motor = M;
            else
                error('El motor no es una instancia de la clase Motor.');
            end
        end
        function set.embrague(coche, E)
            if isa(E, 'Embrague')
                coche.embrague = E;
            else
                error('El embrague no es una instancia de la clase Embrague.');
            end
        end
        function set.cajadecambios(coche, CC)
            if isa(CC, 'CajaCambios')
                coche.cajadecambios = CC;
            else
                error('La caja de cambios no es una instancia de la clase CajaCambios.');
            end
        end
        function set.ruedas(coche, R)
            if isa(R, 'Rueda')
                coche.ruedas = R;
            else
                error('La rueda no es una instancia de la clase Rueda.');
            end
        end
        function set.resaero(coche, RA)
            if isa(RA, 'ResAerodinamica')
                coche.resaero = RA;
            else
                error('La resistencia aerodinámica no es una instancia de la clase ResAerodinamica.');
            end
        end
        function set.resgrad(coche, RG)
            if isa(RG, 'ResGradiente')
                coche.resgrad = RG;
            else
                error('La resistencia de gradiente no es una instancia de la clase ResGradiente.');
            end
        end
        function out = posicionruedacoche(coche, rueda)
            [dim1, dim2] = size(rueda);
            if ~ischar(rueda) || dim1 ~= 1
                error('rueda ha de ser un string.');
            end
            x = coche.leje / 2;
            y = coche.empate / 2;
            
            switch rueda
                case 'rdd'
                    out = [+x, -y, 0];
                case 'rdi'
                    out = [+x, +y, 0];
                case 'rtd'
                    out = [-x, -y, 0];
                case 'rti'
                    out = [-x, +y, 0];
                otherwise
                    error('Esa rueda no existe.');
            end
        end
        function out = posicionruedamundo(coche, rueda)
            [dim1, dim2] = size(rueda);
            if ~ischar(rueda) || dim1 ~= 1
                error('rueda ha de ser un string.');
            end
            x = coche.leje / 2;
            y = coche.empate / 2;
            
            out = coche.posicion3 + coche.rotar( coche.posicionruedacoche(rueda), coche.direccion4(1:3), coche.direccion4(4));
            
        end
        function out = pendiente(coche)
            out = pi/2 - acos( dot(coche.direccion4(1:3), [0, 0, 1] ));
        end
        function rotarcoche(coche, eje, angulo)
            coche.direccion4(1:3) = coche.rotar(coche.direccion4(1:3), eje, angulo);
        end
        function [potencia, torquemotor, nmotor, trrd, trrt, resrodadura, resaero, resgradiente] = fuerzas(coche)
            [nmotor, torquemotor, potencia] = coche.motor.actua;
            
            nembrague = nmotor;
            torqueembrague = coche.embrague.actua(nmotor) * torquemotor;
            
            [ncc, torquecc] = coche.cajadecambios.actuar(nembrague, torqueembrague);
            
            % Tracción de ruedas delanteras y traseras
            trrd = coche.ruedas.ftraccion(torquecc/2);
            trrt = coche.ruedas.ftraccion(0);
            
            resrodadura = coche.ruedas.frodadura(norm(coche.velocidad3), coche.masa * 9.81/4);
            resaero = coche.resaero.actua(norm(coche.velocidad3));
            resgradiente = coche.resgrad.actua(coche.pendiente);
            
            ncc
            deslizamiento = coche.ruedas.deslizamiento(ncc, norm(coche.velocidad3))
            
            %out = [potencia, torquemotor, nmotor, trrd, trrt, resrodadura, resaero, resgradiente];
        end
        function simular(coche, deltat)
            [potencia, torquemotor, nmotor, trrd, trrt, resrodadura, resaero, resgradiente] = coche.fuerzas;
            
            
            % Fuerzas en el centro de masas
            if abs(trrd) - abs(resrodadura) - abs(resgradiente) < 0
                fcm = 0;
            else
                fcm = 2 * trrd + 2 * trrt - 4*resrodadura - resaero - resgradiente
            end
            
            % Actualizar posición y velocidad
            
            coche.posicion3 = coche.posicion3 + coche.velocidad3 * deltat;
            
            aceleracion = fcm / coche.masa
            aceleracion3 = coche.direccion4(1:3) * aceleracion;
            coche.velocidad3 = coche.velocidad3 + aceleracion3;
            
            
        end
    end
    
end