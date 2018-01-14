function rpn
% rpn calculator
fprintf(['RPN calculator. Type h or help to see available functions.'...
        '\n\tWentao Jiang, 20180113\n']);
stack = NaN(10000);
ind = 1;
singlefuns = {'exp','log','ln','sqrt','sq',...
    'sin','cos','tan','cot','sec','csc','asin','acos','atan','acot'};
doublefuns = {'+','-','*','/','^'};
consts = {'pi'};
syscmd = {'exit','h','help','d','c'};
while true
    s = input('rpn:>>','s');
    try
        s2d = eval(s);
    catch err
        s2d = str2double(s);
    end
    
    if ~isnan(s2d)
        stack(ind) = s2d;
        ind = ind + 1;
    elseif checkcmd(s, syscmd)
        switch s
            case 'exit'
                return;
            case 'h'
                fprintf('Commands:\n\th: help\thelp: help\n\td: delete last number.\n\tc: clear stack.\n')
                fprintf('Type exit to exit.\nSingle input functions:\n');
                disp(singlefuns);
                disp('Double input functions:');
                disp(doublefuns);
            case 'help'
                fprintf('Commands:\n\th: help\thelp: help\n\td: delete last number.\n\tc: clear stack.\n')
                fprintf('Type exit to exit.\nSingle input functions:\n');
                disp(singlefuns);
                disp('Double input functions:');
                disp(doublefuns);
            case 'c'
                ind = 1;
            case 'd'
                if ind > 1
                    ind = ind - 1;
                else
                    warning('Stack already empty.');
                end
        end
    elseif checkcmd(s, singlefuns)
        if ind - 1 < 1
            warning('Not enough input!');
            continue;
        end
        val = stack(ind-1);
        val = eval(sprintf('%s(%.8e)',s,val) );
        stack(ind-1) = val;
    elseif checkcmd(s, doublefuns)
        if ind - 1 < 2
            warning('Not enough input!');
            continue;
        end
        ind = ind - 1;
        val2 = stack(ind);
        val1 = stack(ind-1);
        val1 = eval(sprintf('%.8e%s%.8e',val1,s,val2) );
        stack(ind-1) = val1;
    else
        disp('Command not found!');
    end
    dispstk(stack, ind);
end
end

function dispstk(stack,ind)
% display numbers in the stack
for ii = 1:(ind-1)
    fprintf([num2str(stack(ii)) '\n']);
end
end

function res = checkcmd(str, cmdset)
% check command, true if command str found in cmdset
res = cellfun(@(s)strcmpi(s,str),cmdset,'UniformOutput',false);
res = max([res{:}]);
end
