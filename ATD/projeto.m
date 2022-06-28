opt = menu("Experiência:", "acc_exp41_user20.txt", "acc_exp42_user21.txt",...
    "acc_exp43_user21.txt", "acc_exp44_user22.txt", "acc_exp45_user22.txt", ...
    "acc_exp46_user23.txt", "acc_exp47_user23.txt", "acc_exp48_user24.txt", ...
    "acc_exp49_user24.txt", "acc_exp50_user25.txt");
switch(opt)
    case 1
        import("acc_exp41_user20.txt", 41, 20);
    case 2
        import("acc_exp42_user21.txt", 42, 21);
    case 3
        import("acc_exp43_user21.txt", 43, 21);
    case 4
        import("acc_exp44_user22.txt", 44, 22);
    case 5
        import("acc_exp45_user22.txt", 45, 22);
    case 6
        import("acc_exp46_user23.txt", 46, 23);
    case 7
        import("acc_exp47_user23.txt", 47, 23);
    case 8
        import("acc_exp48_user24.txt", 48, 24);
    case 9
        import("acc_exp49_user24.txt", 49, 24);
    case 10
        import("acc_exp50_user25.txt", 50, 25);
end

function import(fileName, experiment, user)
    labels = getLabels(experiment, user);
    opt = menu("Análise Do Sinal:", "Número de passos", "Gráficos", "Deteção de atividades");
    if(opt==1)
        x = getSignal(fileName,1);
        NPM(x,labels);
    elseif(opt==2)
        opt = menu("Gráficos:", "DFT", "STFT");
        if(opt==1)
            opt = menu("Atividade:", "Dinâmicas", "Estáticas", "Transições");
            opt2 = menu("Eixo", "x", "y", "z");
            x = getSignal(fileName,opt2);
            DFTGrafic(x, labels,opt);
        else
            opt2 = menu("Eixo", "x", "y", "z");
            opt = menu("Linhas De Marcação:", "Sim", "Não");
            x = getSignal(fileName,opt2);
            figure(1);
            subplot(3,1,2);
            Grafic(x, labels);
            STFT(x, labels, opt);
        end
    else
        x = getSignal(fileName,1);
        y = getSignal(fileName,2);
        z = getSignal(fileName,3);
        figure(1);
        subplot(2,1,1);
        Grafic(x, labels);
        subplot(2,1,2);
        detecao(x, y, z, labels);
    end
end
   
function x = getLabels(experiment, user)
    x = [];
    fileId = fopen("labels.txt", "r");
    while ~feof(fileId)
        aux = str2num(fgets(fileId));
        if(aux(1,1)==experiment & aux(1,2)== user)
            while (~feof(fileId)) & (aux(1,1)==experiment & aux(1,2)== user)
                x = [x; aux(1,3:end)];
                aux = str2num(fgets(fileId));
            end
            fclose(fileId);
            break;
        end
    end
end

function x = getSignal(fileName, opt)

    x = [];
    fileId = fopen(fileName, "r");
    while ~feof(fileId)
        if(opt == 3)
            y=fscanf(fileId, "%f", 1);
            y=fscanf(fileId, "%f", 1);
        end
        if(opt == 2)
            y=fscanf(fileId, "%f", 1);
        end
        x = [x fscanf(fileId, "%f", 1)];
        if(opt == 2)
            y=fscanf(fileId, "%f", 1);
        end
        if(opt == 1)
            y=fscanf(fileId, "%f", 1);
            y=fscanf(fileId, "%f", 1);
        end
    end
    fclose(fileId);
end

function Grafic(x, labels)
    t=1;
    sinal = [2; -1]; 
    for i = 1:size(labels,1)
        switch labels(i,1)
            case 1 % andar
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)),"r");
                text(n(1),sinal(mod(i,2)+1),"W");
                t=labels(i,3)+1;
                hold on;
            case 2 % subir escadas
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 2; %laranja
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"WU");
                t=labels(i,3)+1;
                hold on;
            case 3 % descer escadas
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 7; %vermelho escuro
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"WV");
                t=labels(i,3)+1;
                hold on;
            case 4 %sentado
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 1; %azul
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"SIT");
                t=labels(i,3)+1;
                hold on;
            case 5 % de pé
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)), "m");
                text(n(1),sinal(mod(i,2)+1),"ST");
                t=labels(i,3)+1;
                hold on;
            case 6 % deitado
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)), "g");
                text(n(1),sinal(mod(i,2)+1),"L");
                t=labels(i,3)+1;
                hold on;
            case 7 % de pé para sentado
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 6;%azul
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"ST_S_I_T");
                t=labels(i,3)+1;
                hold on;
            case 8 % sentado para de pé
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)),"c");
                text(n(1),sinal(mod(i,2)+1),"SIT_S_T");
                t=labels(i,3)+1;
                hold on;
            case 9 % sentado para deitado
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)),'b');
                text(n(1),sinal(mod(i,2)+1),"SIT_L");
                t=labels(i,3)+1;
                hold on;
            case 10 % deitado para sentado
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 5; %green
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"L_S_I_T");
                t=labels(i,3)+1;
                hold on;
            case 11 % de pé para deitado
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 4;% dark purple
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"ST_L");
                t=labels(i,3)+1;
                hold on;
            case 12 % deitado para de pé
                n = t:labels(i,2)-1;
                n = n./50;
                plot(n,x(1,t:labels(i,2)-1),"k");
                t=labels(i,2);
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 3;%yelow
                n = t:labels(i,3);
                n = n./50;
                plot(n,x(1,t:labels(i,3)));
                text(n(1),sinal(mod(i,2)+1),"L_S_T");
                t=labels(i,3)+1;
                hold on;
        end
    end
    n = t:size(x,2);
    n = n./50;
    plot(n,x(1,t:end),"k");
    xlabel("t [s]");
    title("Sinal");
    hold off; 
end

function DFTGrafic(x, labels, opt)
    l=[]
    switch(opt)
        case 1
        l = [1 2 3]
        case 2
            l = [4 5 6]
        case 3
            l = [7 8 9 10 11 12]
    end
    index = 1
    for i = 1:size(labels,1)
        
        if(size(l(l==labels(i,1)),2)==0)
            continue;
        end
        subplot(2, 4, index);
        index = index +1;
        xx = x(1,labels(i,2):labels(i,3));
        C0 = mean(xx);
        xx = xx-C0;
        h = hamming(numel(xx));
        %size(xx)
        %size(h)
        xx=xx.*h';
        X = fftshift(DFT(xx));
        X = abs(X);
        X = X';
        f = [];
        fs = 50;
        N = size(X,2);
        if(mod(N,2)==0)
            f = -fs/2:fs/N:fs/2-fs/N;
        else
            f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
        end
        plot(f,X);
        switch labels(i,1)
            case 1 % andar
                title("WALKING");
            case 2 % subir escadas
               title("WALKING UPSTAIRS");
            case 3 % de pé
               title("WALKING DOWNSTAIRS");
            case 4 % deitado
                title("SITTING");
            case 5 % de pé para sentado
                title("STANDING");
            case 6 % sentado para de pé
                title("LAYING");
            case 7 % sentado para deitado
                title("STAND TO SIT");
            case 8 % deitado para sentado
                title("SIT TO STAND");
            case 9 % de pé para deitado
                title("SIT TO LIE");
            case 10 % deitado para de pé
                title("LIE TO SIT");
            case 11 % deitado para de pé
                title("STAND TO LIE");
            case 12 % deitado para de pé
                title("LIE TO STAND");
        end
    end               
end

function NPM(x, labels)
    npm=[];
    atividade = ["W", "WU", "WD"];
    valores =[];
    for i = 1:size(labels,1)
        if(labels(i,1)~=1 && labels(i,1)~=2 && labels(i,1)~=3)
            continue;
        end
        xx = x(1,labels(i,2):labels(i,3));
        C0 = mean(xx);
        xx = xx-C0;
        X = fftshift(DFT(xx));
        X = abs(X);
        X = X';
        f = [];
        fs = 50;
        N = size(X,2);
        if(mod(N,2)==0)
            f = -fs/2:fs/N:fs/2-fs/N;
        else
            f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
        end
        f_relevantes = relevantes(X,f, 0.05);
        aux = f(X==max(X));
        T_medio = 1 / abs(aux(1));
        npm = [npm [atividade(labels(i,1));60/T_medio]];
        valores = [valores (60/T_medio)];
    end   
    disp("Passos por minuto:");
    disp(npm);
    disp("Media:")
    disp(mean(valores));
    disp("Desvio Padrão:");
    disp(std(valores));
end

function f_relevantes = relevantes(X, f, min)
    max_x = max(X);
    min_x = min*max_x;
    [pks,locs] = findpeaks(X(1,:),"MinPeakHeight", min_x);
    f_relevantes = f(locs);
    f_relevantes = f_relevantes(f_relevantes>0);
end

function output = STFT(x, labels, opt)
     x = x'; 
     N = numel(x);
     fs = 50;
     t = linspace(0,(N-1)/fs,N);
     %Tframe = 0.256*10;
     %Toverlap = 0.128*10;
     Tframe = 1.5;
     Toverlap = 0.75;
     Nframe = round(Tframe*fs);
     Noverlap = round(Toverlap*fs);
     
     h = hamming(Nframe);
     
     f_frame = [];
     if(mod(Nframe,2)==0)
         f_frame = -fs/2:fs/Nframe:fs/2-fs/Nframe;
     else
         f_frame = -fs/2+fs/(2*Nframe):fs/Nframe:fs/2-fs/(2*Nframe);
     end
     media = find(f_frame==0);
     f_relevantes  = [];
     nframes = 0;
     tframes = [];
     
     espectro =[];
     for  i = 1:Nframe-Noverlap:N-Nframe
         x_frame = x(i:i+Nframe-1);
         C0 = mean(x_frame);
         x_frame = x_frame-C0;
         x_frame = x_frame.*h;
         X_frame = abs(fftshift(DFT(x_frame)));
         
         X_frame_max = max(X_frame);
         index = find(abs(X_frame-X_frame_max)<0.0001);
         X_frame(media)=C0;
         espectro = [espectro X_frame(f_frame>=0)];
         
         f_relevantes = [f_relevantes, abs(f_frame(index(1)))];
         nframes = nframes+1;
         t_frame = t(i:i+Nframe-1);
         tframes = [tframes, t_frame(round(Nframe/2+1))];
     end
     subplot(3,1,1); 
     plot(tframes, f_relevantes, "o");
     hold on;
     for i = 1:size(labels,1)
        xline(labels(i,2)/50, "r");
        xline(labels(i,3)/50, "r");
     end
     hold off;
     xlabel("t [s]");
     ylabel("f [Hz]");
     title("Frequências mais relevantes");
     
     tt = t(1:Nframe-Noverlap:N-Nframe);
     ff = f_frame(f_frame>=0)';
     subplot(3,1,3); 
     s = mesh(tt, ff, espectro);
     s.FaceColor = 'flat';
     if(opt==1)
        hold on;
        for i = 1:size(labels,1)
            xline(labels(i,2)/50, "r");
            xline(labels(i,3)/50, "r");
        end
        hold off;
     end
     xlabel("t [s]");
     ylabel("f [Hz]");
     title("Espectro de frequências");
     output = espectro;
end

function detecao(x, y, z, labels)
     x = x';
     y = y';
     z = z';
     N = numel(z);
     fs = 50;
     t = linspace(0,(N-1)/fs,N);
     %Tframe = 0.256*10;
     %Toverlap = 0.128*10;
     Tframe = 2.5;
     Toverlap = 1.25;
     Nframe = round(Tframe*fs);
     Noverlap = round(Toverlap*fs);
     
     h = hamming(Nframe);
     
     if(mod(Nframe,2)==0)
         f_frame = -fs/2:fs/Nframe:fs/2-fs/Nframe;
     else
         f_frame = -fs/2+fs/(2*Nframe):fs/Nframe:fs/2-fs/(2*Nframe);
     end
     f_relevantes  = [];
     tframes = [];
     atividade =[];
     for  i = 1:Nframe-Noverlap:N-Nframe
         t_frame = t(i:i+Nframe-1);
         tframes = [tframes, t_frame(round(Nframe/2+1))];
         
         x_frame = x(i:i+Nframe-1);
         C0 = mean(x_frame);
         x_frame = x_frame-C0;
         x_frame = x_frame.*h;
         X_frame = abs(fftshift(DFT(x_frame)));
         
         y_frame = y(i:i+Nframe-1);
         C0 = mean(y_frame);
         y_frame = y_frame-C0;
         y_frame = y_frame.*h;
         Y_frame = abs(fftshift(DFT(y_frame)));
         
         z_frame = z(i:i+Nframe-1);
         C0 = mean(z_frame);
         z_frame = z_frame-C0;
         z_frame = z_frame.*h;
         Z_frame = abs(fftshift(DFT(z_frame)));
         
         a = atividades(X_frame, Y_frame, Z_frame, f_frame);
         if(a~=0)
             atividade = [atividade a];
             continue;
         end
         
         Z_frame_max = max(Z_frame);
         index = find(abs(Z_frame-Z_frame_max)<0.0001);
         f = abs(f_frame(index(1)));
         f2 = abs(f-0.65);
         
         if(f2<0.5)
            fr = relevantes(Z_frame', f_frame, 0.65);
            if(size(fr,2)>2)
                atividade = [atividade 3];%WD
                continue;
            end
            atividade = [atividade 5];%WU
            continue;
         end
         f2 = abs(f-2.7);
         if(f2<0.5)
             fr = relevantes(Z_frame', f_frame, 0.55);
             if(size(fr,2)>2)
                atividade = [atividade 3];%WD
                continue;
            end
            atividade = [atividade 4];%W
            continue;
         end
         
         atividade = [atividade 3];%WD
     end
     y=['E','T','D','W','U'];
     plot(tframes, atividade, "o");
     set(gca,'yticklabel',y.')
     hold on;
     for i = 1:size(labels,1)
        xline(labels(i,2)/50);
        xline(labels(i,3)/50);
     end
     hold off;
     xlabel("t [s]");
     ylabel("atividade");
     title("Dinamicas");
     
end

function detecao_generalizada(x, y, z, labels)
     x = x';
     y = y';
     z = z';
     N = numel(z);
     fs = 50;
     t = linspace(0,(N-1)/fs,N);
     %Tframe = 0.256*10;
     %Toverlap = 0.128*10;
     Tframe = 2.5;
     Toverlap = 1.25;
     Nframe = round(Tframe*fs);
     Noverlap = round(Toverlap*fs);
     
     h = hamming(Nframe);
     
     if(mod(Nframe,2)==0)
         f_frame = -fs/2:fs/Nframe:fs/2-fs/Nframe;
     else
         f_frame = -fs/2+fs/(2*Nframe):fs/Nframe:fs/2-fs/(2*Nframe);
     end
     f_relevantes  = [];
     tframes = [];
     atividade =[];
     for  i = 1:Nframe-Noverlap:N-Nframe
         t_frame = t(i:i+Nframe-1);
         tframes = [tframes, t_frame(round(Nframe/2+1))];
         
         x_frame = x(i:i+Nframe-1);
         C0 = mean(x_frame);
         x_frame = x_frame-C0;
         x_frame = x_frame.*h;
         X_frame = abs(fftshift(DFT(x_frame)));
         
         y_frame = y(i:i+Nframe-1);
         C0 = mean(y_frame);
         y_frame = y_frame-C0;
         y_frame = y_frame.*h;
         Y_frame = abs(fftshift(DFT(y_frame)));
         
         z_frame = z(i:i+Nframe-1);
         C0 = mean(z_frame);
         z_frame = z_frame-C0;
         z_frame = z_frame.*h;
         Z_frame = abs(fftshift(DFT(z_frame)));
         
         a = atividades_generalizada(X_frame, Y_frame, Z_frame, f_frame);
         if(a~=0)
             atividade = [atividade a];
             continue;
         end
         
         Z_max = max(Z_frame);
         z_fr = relevantes(Z_frame', f_frame, 0.60);
         if(size(z_fr,2)>3)
             atividade = [atividade 3];%WD
             continue;
         end
         
         x_max = max(X_frame);
         x_fr = relevantes(X_frame', f_frame, 0.25);
         
         if( size(x_fr,2)<5)
             atividade = [atividade 5];%WU
             continue;
         end
       
         atividade = [atividade 4];%W
     end
     y=['E','T','D','W','U'];
     plot(tframes, atividade, "o");
     set(gca,'yticklabel',y.')
     hold on;
     for i = 1:size(labels,1)
        xline(labels(i,2)/50);
        xline(labels(i,3)/50);
     end
     hold off;
     xlabel("t [s]");
     ylabel("atividade");
     title("Dinamicas");
     
end

function output = atividades(x, y, z, f_frame)
    y_max = max(y);
    index = find(abs(y-y_max)<0.0001);
    f = abs(f_frame(index(1)));
    f1 = abs(f-1.3);
    f2 = abs(f-1.8);
    y_fr = relevantes(y', f_frame, 0.70);
    
    x_max = max(x);
    index = find(abs(x-x_max)<0.0001);
    f3 = abs(f_frame(index(1)));
    f3 = abs(f-1.8);
    x_fr = relevantes(x', f_frame, 0.60);
    
    if(f1<0.3 || f2<0.3)

        if(size(y_fr,2)<3)
            output = 0;%D
            return;
        end

        if(f3<0.4 && size(x_fr,2)<3)
            output = 0;%D
        end
    end
    
    z_max = max(z);
    
    x_fr = relevantes(x', f_frame, 0.60);
    z_fr = relevantes(z', f_frame, 0.60);

    if(size(x_fr,2)>1 || size(y_fr,2)>1 || size(z_fr,2)>1)
        output = 1;%E
        return;
    end
    output = 2;%T
end

function output = atividades_generalizada(x, y, z, f_frame)
    x_max = max(x); 
    y_max = max(y);
    z_max = max(z);
    
    x_fr = relevantes(x', f_frame, 0.70);
    y_fr = relevantes(y', f_frame, 0.70);
    z_fr = relevantes(z', f_frame, 0.70);
    
    
    index = find(abs(x-x_max)<0.0001);
    x_f = abs(f_frame(index(1)));
    
    index = find(abs(y-y_max)<0.0001);
    y_f = abs(f_frame(index(1)));
    
    index = find(abs(z-z_max)<0.0001);
    z_f = abs(f_frame(index(1)));
    
    if(0.5<x_f && x_f<2.3)
            output = 0;%D
            return;
    end
    
    x_fr = relevantes(x', f_frame, 0.45);
    y_fr = relevantes(y', f_frame, 0.45);
    z_fr = relevantes(z', f_frame, 0.45);
    
    if(x_f<1 && y_f<1 && z_f<1)
        if(size(x_fr,2)<2 && size(y_fr,2)<2 && size(z_fr,2)<2 )
            output = 2;%T
            return;
        end
    end
    
    output = 1; %E
    return;
end

function output=DFT(x)
    if(size(x,2)==1)
        x=x';
    end
    N = numel(x);
    n = 0:N-1;
    output = zeros(size(x,2),1);
    for k=0:N-1
        somatorio = cos((-2*pi/N)*n*k)+j*sin((-2*pi/N)*n*k);
        output(k+1) = x * somatorio';
    end
end
