function M=logAPP_base(y,x,var)
%logAPP��N=1�ı��ʽ
M=log(W(y,x,var)/(W(y,0,var)+W(y,1,var)));
