const API_URL = 'http://localhost/museu/'


function getAcervo(token,id_div=''){

    const data = new URLSearchParams()
        data.append("token", token)

    const myRequest = new Request(API_URL+"API/getItens.php",{
        method : "POST",
        body : data
    });

    const out = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text())        
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));
            } 
        })
    })

    if(id_div == ""){
        return out
    }else{
        out.then((txt)=>{
            const json = JSON.parse(txt)
             
            const main_div = document.getElementById(id_div)
            main_div.innerHTML = ''
            main_div.classList.add('main-content')


            const data = new URLSearchParams()
                data.append("file", 'veiculo.json')

            const myRequest = new Request(API_URL+"API/microdata.php",{
                method : "POST",
                body : data
            });

            fetch(myRequest)
            .then(function (response){
                if (response.status === 200) { 
                    response.text()
                    .then((txt)=>{
                        const microdata = JSON.parse(txt)
    
                        function addLine(obj,key,label=''){
                            label = label=='' ? key : label
                            const line = document.createElement('div')
                            line.className = 'row-item'
                            line.innerHTML = `<label>${label}</label><p ${microdata.hasOwnProperty(key) ? `itemprop="${microdata[key]}"` : ''}>${obj[key]}</p>`
                            return line
                        }
    
                        function addFiles(data){
                            const div = document.createElement('div')
                            div.className = 'img-board'
                            for(let i=0; i<data.files.length; i++){
    
                                const ext = data.files[i].split('.')[data.files[i].split('.').length -1]
                                const filename = data.files[i].split('.')[0]
                                const arq = ['jpg','jpeg','png'].includes(ext) ? 'img' : 'div'
    
                                const sqr = document.createElement('div')
                                sqr.className = 'square-item'
                                sqr.src = data.files[i]
                                sqr.innerHTML = ['jpg','jpeg','png'].includes(ext) ? `<img class="img-item" src="${data.files[i]}">` : `<p>${filename}</p><h1>${ext.toUpperCase()}</h1>`
                                sqr.addEventListener('click',()=>{
                                    window.open(sqr.src, '_blank');
                                })
    
                                div.appendChild(sqr)
                            }
                            return div
                        }
    
                        function capa(obj){
    
                            const div = document.createElement('div')
                            div.className = 'capa-item'
                            div.innerHTML = `<h3>${obj.nome}</h3>`
                            
                            let found=0
                            for(let i=0; i<obj.files.length; i++){
                                
                                const ext = obj.files[i].split('.')[obj.files[i].split('.').length -1]
    
                                if(!found && ['jpg','jpeg','png'].includes(ext)){
                                    found=1
                                    const img = document.createElement('img')
                                    img.className = 'capa-item-img'
                                    img.src = obj.files[i]
                                    div.appendChild(img)
                                    i = obj.files.length
                                }
                            }
                            if(!found){
                                div.innerHTML = `<h4>Veja mais...</h4>`
                                const nome = document.createElement('div')
                                nome.className = 'capa-item-nome'
                                nome.innerHTML = obj.nome
                                div.appendChild(nome)
                            }
                            return div
                        }
    
                        for(let i=0; i<json.length; i++){
    //console.log(json[i])
    
                            const imager = addFiles(json[i])
    
                            const show_div = document.createElement('div')
                            show_div.className = 'show-item'
                            show_div.setAttribute("itemprop", "itemOffered")
                            show_div.setAttribute("itemscope",true)
                            show_div.setAttribute("itemtype", "https://schema.org/Car")
    
                            show_div.appendChild(capa(json[i]))
    
                            const content_div = document.createElement('div')                        
                            content_div.className = 'content-item'
                            content_div.appendChild(addLine(json[i],'acervo','Acervo:'))
                            content_div.appendChild(addLine(json[i],'alt','Altura:'))
                            content_div.appendChild(addLine(json[i],'ano','Ano:'))
                            content_div.appendChild(addLine(json[i],'cat','Categoria:'))
                            content_div.appendChild(addLine(json[i],'chassi','Chassi:'))
                            content_div.appendChild(addLine(json[i],'cilindrada','Cilindradas:'))
                            content_div.appendChild(addLine(json[i],'cilindros','Cilindros:'))
                            content_div.appendChild(addLine(json[i],'comp','Comprimento:'))
                            content_div.appendChild(addLine(json[i],'cor','Cor:'))
                            content_div.appendChild(addLine(json[i],'entre_eixo','Entre Eixo:'))
                            content_div.appendChild(addLine(json[i],'id'))
                            content_div.appendChild(addLine(json[i],'id_acervo'))
                            content_div.appendChild(addLine(json[i],'id_item'))
                            content_div.appendChild(addLine(json[i],'id_veiculo'))
                            content_div.appendChild(addLine(json[i],'larg','Largura:'))
                            content_div.appendChild(addLine(json[i],'lugares','Lugares:'))
                            content_div.appendChild(addLine(json[i],'marca','Marca:'))
                            content_div.appendChild(addLine(json[i],'modelo','Modelo:'))
                            content_div.appendChild(addLine(json[i],'nome','Nome:'))
                            content_div.appendChild(addLine(json[i],'obs','Obs:'))
                            content_div.appendChild(addLine(json[i],'pais','País:'))
                            content_div.appendChild(addLine(json[i],'placa','Placa:'))
                            content_div.appendChild(addLine(json[i],'portas','Portas:'))
                            content_div.appendChild(addLine(json[i],'pot_hp','Potência HP:'))
                            content_div.appendChild(addLine(json[i],'tipo','Tipo:'))
                            content_div.appendChild(addLine(json[i],'vel_max','Velocidade Máxima:'))
                            content_div.appendChild(imager)
    
                            show_div.appendChild(content_div)
                            show_div.addEventListener('click',()=>{
                                const content = document.querySelectorAll('.content-item')
                                for(let i=0; i<content.length; i++){
                                    content[i].classList.remove('show-data')
                                }
                                content_div.classList.add('show-data')
                            })
    
                            main_div.appendChild(show_div)
                        }
                    })  
                } else { 
                    reject(new Error("Houve algum erro na comunicação com o servidor"));
                } 
            })
          
        })
    }
}
