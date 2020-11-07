require 'uri'
require 'net/http'
require 'json'
def request(address, apikey)
    juntos = address + apikey
    uri = URI(juntos)
    response = Net::HTTP.get(uri)
    body = JSON.parse(response)
end
def build_web_page(body)
    photos = body['photos']
    dato_url = photos.map{|x| x['img_src']}
    html = ""
    html += "<html>\n<head>\n<title>Prueba API NASA</title>\n</head>\n<body>\n<h1 align='center'>Prueba API Nasa en Ruby</h1>\n<ul>\n"
    dato_url.each do |photo|
        html += "<li><img src=\"#{photo}\" width='300' height='200'></li>\n" 
    end
    html += "</ul>\n</body>\n</html>"
    File.write('index.html', html)
end
def photos_count(body)
    contador = Hash.new(0)
    body["photos"].each do |name_camera|
        name_camera["camera"].each do |k, v|
            if k == "name"
                puts v
                if contador.include? v
                    contador[v] += 1
                else
                    contador[v] = 1
                end
            end
        end
    end
    puts "Nuevo Hash con nombre de cámara y número de fotos por cámara\n #{contador}"
end
body = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=1', '&api_key=DEMO_KEY')
build_web_page(body)
photos_count(body)