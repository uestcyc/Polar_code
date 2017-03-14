function createfigure(X1, Y1, X2, Y2)
%CREATEFIGURE(X1, Y1, X2, Y2)
%  X1:  x ���ݵ�ʸ��
%  Y1:  y ���ݵ�ʸ��
%  X2:  x ���ݵ�ʸ��
%  Y2:  y ���ݵ�ʸ��

%  �� MATLAB �� 31-Mar-2016 16:15:50 �Զ�����

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1,'YScale','log','YMinorTick','on');
box(axes1,'on');
hold(axes1,'all');

% ���� semilogy
semilogy(X1,Y1,'Parent',axes1,'Marker','*','Color',[0 0 1],'DisplayName','k=512');

% ���� semilogy
semilogy(X2,Y2,'Parent',axes1,'Marker','*','Color',[1 0 0],'DisplayName','k=171');

% ���� xlabel
xlabel({'SNR dB'});

% ���� ylabel
ylabel({'BER'});

% ���� legend
legend(axes1,'show');

