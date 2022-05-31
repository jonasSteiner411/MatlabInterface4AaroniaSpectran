function cpy = myCopy(in)
%MYDEEPCOPY creates a struct with fieldnames equal to the propertie names
%of the input value in. All values are then copyed (this still might be a shallow copy)

fieldNames = properties(in);
for idx = 1:numel(fieldNames)
    cpy.(fieldNames{idx}) = in.(fieldNames{idx});
end
end

