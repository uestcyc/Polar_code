function p = logAPPBase(y, x, var)
%�����ŵ�����������ʺ���logAPP(x|y)

p = log(W(y, x, var)/(W(y, 0, var)+W(y, 1, var)));
