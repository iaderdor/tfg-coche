classdef ResGradiente < handle
   properties (SetAccess = private)
       masa
   end
   methods
       function RG = ResGradiente(masa)
           RG.masa = masa;
       end
       
       function set.masa(RG, masa)
           [dim1, dim2] = size(masa);
           if dim1 ~= 1 || dim2 ~= 1 || ~isnumeric(masa)
               error('La masa ha de ser un número.');
           elseif masa < 0
               error('La masa debe ser mayor que 0.');
           else
               RG.masa = masa;
           end
       end
       
       % La inclinación en radianes
       function out = actua(RG, inclinacion)
           out = RG.masa * 9.81 * sin(inclinacion);
       end
    end
end