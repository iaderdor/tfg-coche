classdef ResAerodinamica < handle
   properties (SetAccess = private)
       coefaero
       area
       densaire
   end
   methods
       function RA = ResAerodinamica(coefaero, area, densaire)
           RA.coefaero = coefaero;
           RA.area = area;
           RA.densaire = densaire;
       end
       
       function set.coefaero(R, coefaero)
           [dim1, dim2] = size(coefaero);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(coefaero)
               error('El coeficiente aerodinámico ha de ser un número.');
           elseif coefaero < 0
               error('El coeficiente aerodinámico debe ser mayor que 0.');
           else
               R.coefaero = coefaero;
           end
       end
       
       function set.area(R, area)
           [dim1, dim2] = size(area);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(area)
               error('El área del coche ha de ser un número.');
           elseif area < 0
               error('El área del coche debe ser mayor que 0.');
           else
               R.area = area;
           end
       end
       
       function set.densaire(R, densaire)
           [dim1, dim2] = size(densaire);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(densaire)
               error('La densidad del aire ha de ser un número.');
           elseif densaire < 0
               error('La densidad del aire debe ser mayor que 0.');
           else
               R.densaire = densaire;
           end
       end
       
       function out = actua(RA, velocidad)
           out = RA.coefaero * RA.area * RA.densaire / 2 * velocidad^2;
       end
    end
end