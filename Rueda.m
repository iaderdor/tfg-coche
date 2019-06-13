classdef Rueda < handle
   properties (SetAccess = private)
       radio
       densidad
       pedalfreno
   end
   methods
       function R = Rueda(radio,densidad)
           R.radio = radio;
           R.densidad = densidad;
           R.pedalfreno = 0;
       end
       
       function set.radio(R, radio)
          [dim1, dim2] = size(radio);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(radio)
               error('El radio de la rueda debe ser un número');
           elseif radio < 0
               error('El radio de la rueda debe ser mayor que 0.');
           else
               R.radio = radio;
           end
       end
       
       function set.densidad(R, densidad)
        [dim1, dim2] = size(densidad);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(densidad)
               error('La densidad ha de ser un número debe ser un número.');
           elseif densidad < 0
               error('La densidad ha de ser un número mayor que 0.');
           else
               R.densidad = densidad;
           end 
       end
              
       function set.pedalfreno(R, pedalfreno)
           [dim1, dim2] = size(pedalfreno);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(pedalfreno)
               error('Pedal debe ser un número.');
           elseif pedalfreno < 0 || pedalfreno > 1
               error('Pedal debe ser un número entre 0 y 1.');
           else
               R.pedalfreno = pedalfreno;
           end
       end
       
       % Coeficiente de resistencia a la rodadura
       % La velocidad ha de ser introducida en m/s
       function out = coefrrodadura(R, velocidad)
           f0 = 9e-3;
           f1 = 2e-3;
           f4 = 3e-4;
           v0 = 100/3.6;
           out = f0 + f1 * velocidad / v0 + f4 * (velocidad / v0 )^4;
       end
       
       % Valor de la fuerza de rodadura
       % La fuerza normal en newtons [N]
       function out = frodadura(R, velocidad, fnormal)
           out = fnormal * R.coefrrodadura(velocidad);
       end
       
       % Nos devuelve la fuerza de tracción que realiza la rueda
       function out = ftraccion(R, tau)
           out = R.radio*tau;
       end
       
       function out = deslizamiento(R, n, velocidad)
          out = - (velocidad - R.radio * n) / velocidad;
       end
   end
end