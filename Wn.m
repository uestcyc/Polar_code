function M=Wn(y,u_hat,ui,N,i,var)
%���������ŵ�ת�ƺ���
%���������Ǽ����������ĳһ�������·����APPֵ��Ȼ�����ѡ·
%yΪ����������u_hatΪ�ն˶���Ϣ�Ĺ���,ǰ(i-1)����NΪ�볤��iΪ��ǰAPP����ı���λ��

if N~=2             %δ����ݹ���ֹ�������ݹ����
    if mod(i,2)==1
        if i==1
            M=0.5*(Wn(y(1:N/2),u_hat,mod(ui+0,2),N/2,i,var)*Wn(y(N/2+1:N),u_hat,0,N/2,i,var)+Wn(y(1:N/2),u_hat,mod(ui+1,2),N/2,i,var)*Wn(y(N/2+1:N),u_hat,1,N/2,i,var));
        else
            uoe=mod(u_hat(1:2:i-1)+u_hat(2:2:i-1),2);
            ue=u_hat(2:2:i-1);
            M=0.5*(Wn(y(1:N/2),uoe,mod(ui+0,2),N/2,(i+1)/2,var)*Wn(y(N/2+1:N),ue,0,N/2,(i+1)/2,var)+Wn(y(1:N/2),uoe,mod(ui+1,2),N/2,(i+1)/2,var)*Wn(y(N/2+1:N),ue,1,N/2,(i+1)/2,var));
        end
    else
        uoe=mod(u_hat(1:2:i-2)+u_hat(2:2:i-2),2);
        ue=u_hat(2:2:i-2);
        M=0.5*Wn(y(1:N/2),uoe,mod(u_hat(i-1)+ui,2),N/2,i/2,var)*Wn(y(N/2+1:N),ue,ui,N/2,i/2,var);
    end
else
    switch i
        case 1
            M=0.5*(W(y(1),ui,var)*W(y(2),0,var)+W(y(1),mod(ui+1,2),var)*W(y(2),1,var));
        case 2
            M=0.5*W(y(1),mod(u_hat(1)+ui,2),var)*W(y(2),ui,var);
    end
    
end
end