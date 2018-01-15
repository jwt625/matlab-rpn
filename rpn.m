function rpn
% simple rpn (Reverse Polish notation) calculator
% 
% WTJ
% 20180113

fprintf(['Reverse Polish notation calculator. Type h or help to see available functions.'...
        '\n\tWentao Jiang, 20180113\n']);
stack = NaN(10000);
ind = 1;
singlefuns = {'exp','log','ln','sqrt','sq',...
    'sin','cos','tan','cot','sec','csc','asin','acos','atan','acot',...
    'sinh','cosh','tanh','coth','asinh','acosh','atanh','acoth',...
    'ischar','isnumeric','isnan','isinf',...
    'omega2lambda0','lambda02omega','freq2lambda0','lambda02freq'};
doublefuns = {'+','-','*','/','^'};
doublefunsmanual = {'omega2lambda','lambda2omega','freq2lambda','lambda2freq'};
syscmd = {'exit','h','help','d','c','clc'};
% scientific constants
hbar = 1.0545718e-34;
c_const = 299792458;
epsilon0 = 8.854187817e-12;
mu0 = 1.2566370614e-6;

%
while true
    dispstk(stack, ind);
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
                fprintf('Commands:\n\th: help\n\thelp: help\n\td: delete last number.\n\tc: clear stack.\n\tclc: clear command window.\n')
                fprintf('Type exit to exit.\nSingle input functions:\n');
                dispcell(singlefuns);
                disp('Double input functions:');
                dispcell(doublefuns);
            case 'help'
                fprintf('Commands:\n\th: help\n\thelp: help\n\td: delete last number.\n\tc: clear stack.\n\tclc: clear command window.\n')
                fprintf('Type exit to exit.\nSingle input functions:\n');
                dispcell(singlefuns);
                disp('Double input functions:');
                dispcell(doublefuns);
            case 'c'
                ind = 1;
            case 'd'
                if ind > 1
                    ind = ind - 1;
                else
                    warning('Stack already empty.');
                end
            case 'clc'
                clc;
                continue;
        end
    elseif checkcmd(s, singlefuns)
        if ind - 1 < 1
            warning('Not enough input!');
            continue;
        end
        val = stack(ind-1);
        if strcmpi(s,'sq')
            val = eval(sprintf('%.8e^2',val) );
        elseif strcmpi(s,'ln')
            val = eval(sprintf('log(%.8e)',val) );
        else
            val = eval(sprintf('%s(%.8e)',s,val) );
        end
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
    elseif checkcmd(s, doublefunsmanual)
        if ind - 1 < 2
            warning('Not enough input!');
            continue;
        end
        ind = ind - 1;
        val2 = stack(ind);
        val1 = stack(ind-1);
        val1 = eval(sprintf('%s(%.8e,%.8e)',s,val1,val2) );
        stack(ind-1) = val1;
    else
        disp('Command not found!');
    end
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


function dispcell(c)
for ii = 1:length(c)
    fprintf('\t%s\n',c{ii});
end
end

%% manual functions
function l0 = omega2lambda0(omega)
% calculate vacuum wavelength from frequency
c_const = 299792458;
l0 = 2*pi*c_const/omega;
end

function l = omega2lambda(omega, n)
% calculate wavelength from frequency and refractive index
c_const = 299792458;
l = 2*pi*c_const/omega/n;
end

function w = lambda02omega(l0)
c_const = 299792458;
w = 2*pi*c_const/l0;
end

function w = lambda2omega(l, n)
% calculate wavelength from frequency and refractive index
c_const = 299792458;
w = 2*pi*c_const/l/n;
end

function l0 = freq2lambda0(f)
l0 = omega2lambda0(2*pi*f);
end

function l0 = freq2lambda(f,n)
l0 = omega2lambda(2*pi*f,n);
end

function f = lambda02freq(l0)
f = lambda02omega(l0)/2/pi;
end

function f = lambda2freq(l0,n)
f = lambda2omega(l0,n)/2/pi;
end
