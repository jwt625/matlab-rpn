function rpn
% simple rpn (Reverse Polish notation) calculator
% 
% WTJ
% 20180113

fprintf(['Reverse Polish notation calculator.\nType h or help to see available functions.'...
        '\n\tWentao Jiang, 20180113\n']);
stack = NaN(1,1000);
ind = 1;
singlefuns = {'exp','log','ln','sqrt','sq',...
    'sin','cos','tan','cot','sec','csc','asin','acos','atan','acot',...
    'sinh','cosh','tanh','coth','asinh','acosh','atanh','acoth',...
    'ischar','isnumeric','isnan','isinf','isfloat','isinteger',...
    'omega2lambda0','lambda02omega','freq2lambda0','lambda02freq',...
    'deg2rad','rad2deg','ellipke'};
doublefuns = {'+','-','*','/','^'};
doublefunsmanual = {'omega2lambda','lambda2omega','freq2lambda','lambda2freq',...
    'freq2lambda0','lambda02freq','omega2lambda0','deg2rad','rad2deg'};
syscmd = {'exit','h','help','d','c','clc','constants'};
% scientific constants, in SI
consts.e = 2.718281828459045;
consts.hbar = 1.0545718e-34;
consts.c_const = 299792458;
consts.epsilon0 = 8.854187817e-12;
consts.mu0 = 1.2566370614e-6;  % 4pi*1e-7
consts.Z0 = 376.730313461;     % vacuum impedance
consts.G = 6.67408e-11;
consts.e0 = 1.6021766208e-19;
consts.muB = 927.4009994e-26;
consts.muN = 5.050783699e-27;
consts.Phi0 = 2.067833831e-15;  % magnetic flux quantum
consts.phi0 = 2.067833831e-15/2/pi;  % reduced magnetic flux quantum
consts.m_u = 1.660539040e-27;  % atomic mass
consts.NA = 6.022140857e23;
consts.kB = 1.38064852e-23;
consts.ke = 8.988e9;    % coulomb's constant
consts.m_e = 9.10938356e-31;   % electron mass
consts.alpha0 = 7.2973525664e-3;   % fine-structure constant
consts.sigma0 = 5.670367e-8;   % Stefan-Boltzmann constant 
% expand consts struct
fldns = fieldnames(consts);
for ii = 1:length(fldns)
    fldn = fldns{ii};
    eval(sprintf('%s=%.8e;',fldn, consts.(fldn) ) );
end
%
while true
    dispstk(stack, ind);
    s = input('rpn:>>','s');
    try
        s2d = eval(s);
    catch err
        s2d = str2double(s);
    end
    
    if isfloat(s2d) && length(s2d)==1 && ~isnan(s2d)
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
                dispcell(doublefunsmanual);
            case 'help'
                fprintf('Commands:\n\th: help\n\thelp: help\n\td: delete last number.\n\tc: clear stack.\n\tclc: clear command window.\n')
                fprintf('Type exit to exit.\nSingle input functions:\n');
                dispcell(singlefuns);
                disp('Double input functions:');
                dispcell(doublefuns);
                dispcell(doublefunsmanual);
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
            case 'constants'
                disp(consts);
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
%     fprintf([num2str(stack(ii)) '\n']);
    fprintf('%.8e\n', stack(ii));
end
end

function res = checkcmd(str, cmdset)
% check command, true if command str found in cmdset
res = cellfun(@(s)strcmpi(s,str),cmdset,'UniformOutput',false);
res = max([res{:}]);
end


function dispcell(c)
for ii = 1:length(c)
    fprintf('\t%s,',c{ii});
    if mod(ii,5) == 0
        fprintf('\n');
    end
end
fprintf('\n');
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

function r = deg2rad(d)
r = deg*pi/180;
end

function d = rad2deg(r)
d = r/pi*180;
end