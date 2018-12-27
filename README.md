# elasticsearch-install-plugin

インストールしたいプラグインをentrypointのところに書きます。

例） /tmp/install-plugin.sh <プラグイン名>

あとは、通常通りdocker-compose up -d で初回起動時にプラグインをインストールします。
２回目以降は、インストールしようとするとエラーになるため、スキップします。

```
version: '2'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.5.4
    container_name: elasticsearch
    environment:
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata65:/usr/share/elasticsearch/data
      ##################   for plugin install   ##################
      - ./install-plugin.sh:/tmp/install-plugin.sh
    ports:
      - 9200:9200
    networks:
      - esnet
    ############################ here ############################
    entrypoint: >
       bash -c "chmod +x /tmp/install-plugin.sh &&
                /tmp/install-plugin.sh analysis-kuromoji && 
                /tmp/install-plugin.sh repository-s3 && 
               docker-entrypoint.sh"
  kibana:
    image: docker.elastic.co/kibana/kibana:6.5.4
    container_name: kibana
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch
    links:
      - elasticsearch:elasticsearch
    networks:
      - esnet

volumes:
  esdata654:
    driver: local

networks:
  esnet:
```
