function L=lr_new(y,u_hat,N,i,var)
%�����������������Ȼ��,����ʹ�õĵݹ��˼·
%����y,Ϊ����������,u_hatΪǰ���������,NΪ�볤,iΪ��ǰҪ���������������

if N~=1                         %û������ݹ���ֹ����,�ݹ����
    if mod(i,2)==1              %iΪ����ʱ
        if i==1
            L=(lr_new(y(1:N/2),u_hat,N/2,(i+1)/2,var)*lr_new(y(N/2+1:N),u_hat,N/2,(i+1)/2,var)+1)/(lr_new(y(1:N/2),u_hat,N/2,(i+1)/2,var)+lr_new(y(N/2+1:N),u_hat,N/2,(i+1)/2,var));    %i=1ʱ
            if L>100
                L=100;
            else if L<1/100
                    L=1/100;
                end
            end
        else
            uoe=mod(u_hat(1:2:i-1)+u_hat(2:2:i-1),2);                                                                                                               %i~=1ʱ
            ue=u_hat(2:2:i-1);
            L=(lr_new(y(1:N/2),uoe,N/2,(i+1)/2,var)*lr_new(y(N/2+1:N),ue,N/2,(i+1)/2,var)+1)/(lr_new(y(1:N/2),uoe,N/2,(i+1)/2,var)+lr_new(y(N/2+1:N),ue,N/2,(i+1)/2,var));
            if L>100
                L=100;
            else
                if L<1/100
                    L=1/100;
                end
            end
        end
    else                        %iΪż��ʱ
        uoe=mod(u_hat(1:2:i-2)+u_hat(2:2:i-2),2);
        ue=u_hat(2:2:i-2);
        L=lr_new(y(1:N/2),uoe,N/2,i/2,var)^(1-2*u_hat(i-1))*lr_new(y(N/2+1:N),ue,N/2,i/2,var);
        if L>100
            L=100;
        else
            if L<1/100
                L=1/100;
            end
        end
    end
else
    L=exp(-2*y/var);
    
end
        
    
end


        