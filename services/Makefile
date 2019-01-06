DOCKER_IMAGES = \
	base \
	hadoop \
	spark \
	zeppelin \
	presto \
	shell \
	jupyter

DOCKER_USER ?= "kubelytics"

BASE_DOCKER_VERSION ?= 2.0.0
HADOOP_VERSION ?= 2.9.0
SPARK_VERSION ?= 2.3.1
ZEPPELIN_VERSION ?= 0.8.0
JUPYTER_MINICONDA_VERSION ?= 4.5.12
JUPYTER_VERSION ?= 0.9.4
PRESTO_VERSION ?= 0.206
TTYD_VERSION ?= 1.4.0

docker-images: $(DOCKER_IMAGES)
	@echo Building images completed

all: docker-images print-images
	@echo Done

print-images:
	@echo Images ready for push
	@for image in $(READY_IMAGES); do \
		echo $$image ; \
	done

release: print-images
	@echo Releasing images
	@for image in $(READY_IMAGES); do \
		docker push $$image ; \
	done
	@echo Done

base:
	@echo Building base image $(DOCKER_USER)/base:$(BASE_DOCKER_VERSION)
	@cd base && \
	docker build \
		--tag $(DOCKER_USER)/base:$(BASE_DOCKER_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/base:$(BASE_DOCKER_VERSION))

hadoop:
	@echo Building hadoop image $(DOCKER_USER)/hadoop:$(HADOOP_VERSION)
	@cd hadoop/docker && \
	docker build \
        --build-arg DOCKER_USER=$(DOCKER_USER) \
        --build-arg BASE_DOCKER_VERSION=$(BASE_DOCKER_VERSION) \
        --build-arg HADOOP_VERSION="hadoop-$(HADOOP_VERSION)" \
        --tag $(DOCKER_USER)/hadoop:$(HADOOP_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/hadoop:$(HADOOP_VERSION))

spark:
	@echo Building spark image $(DOCKER_USER)/spark:$(SPARK_VERSION)-$(HADOOP_VERSION)
	@cd spark/docker && \
	docker build \
        --build-arg DOCKER_USER=$(DOCKER_USER) \
        --build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
        --build-arg SPARK_VERSION="spark-$(SPARK_VERSION)" \
        --tag $(DOCKER_USER)/spark:$(SPARK_VERSION)-$(HADOOP_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/spark:$(SPARK_VERSION)-$(HADOOP_VERSION))

zeppelin:
	@echo Building Zeppelin $(DOCKER_USER)/zeppelin:$(ZEPPELIN_VERSION)-$(SPARK_VERSION)
	@cd zeppelin/docker && \
	docker build \
        --build-arg DOCKER_USER=$(DOCKER_USER) \
        --build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
        --build-arg SPARK_VERSION=$(SPARK_VERSION) \
        --build-arg ZEPPELIN_VERSION=$(ZEPPELIN_VERSION) \
        --tag $(DOCKER_USER)/zeppelin:$(ZEPPELIN_VERSION)-$(SPARK_VERSION)-$(HADOOP_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/zeppelin:$(ZEPPELIN_VERSION)-$(SPARK_VERSION)-$(HADOOP_VERSION))

jupyter:
	@echo Building Jupyter $(DOCKER_USER)/jupyter-ml:$(JUPYTER_MINICONDA_VERSION)-$(SPARK_VERSION)
	@cd jupyter/docker && \
	docker build \
        --build-arg DOCKER_USER=$(DOCKER_USER) \
        --build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
        --build-arg SPARK_VERSION=$(SPARK_VERSION) \
        --build-arg MINICONDA_VERSION=$(JUPYTER_MINICONDA_VERSION) \
        --build-arg JUPYTER_VERSION=$(JUPYTER_VERSION) \
        --tag $(DOCKER_USER)/jupyter-ml:$(JUPYTER_VERSION)-$(SPARK_VERSION)-$(HADOOP_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/jupyter-ml:$(JUPYTER_VERSION)-$(SPARK_VERSION)-$(HADOOP_VERSION))

presto:
	@echo Building Presto $(DOCKER_USER)/presto:$(PRESTO_VERSION)-$(HADOOP_VERSION)
	@cd presto/docker && \
	docker build \
        --build-arg DOCKER_USER=$(DOCKER_USER) \
        --build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
        --build-arg PRESTO_VERSION=$(PRESTO_VERSION) \
        --tag $(DOCKER_USER)/presto:$(PRESTO_VERSION)-$(HADOOP_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/presto:$(PRESTO_VERSION)-$(HADOOP_VERSION))

shell:
	@echo Building Shell Container $(DOCKER_USER)/shell:$(HADOOP_VERSION)-$(SPARK_VERSION)-$(PRESTO_VERSION)
	@cd shell/docker && \
	docker build \
        --build-arg DOCKER_USER=$(DOCKER_USER) \
        --build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
        --build-arg SPARK_VERSION=$(SPARK_VERSION) \
        --build-arg PRESTO_VERSION=$(PRESTO_VERSION) \
        --build-arg TTYD_VERSION=$(TTYD_VERSION) \
        --tag $(DOCKER_USER)/shell:$(HADOOP_VERSION)-$(SPARK_VERSION)-$(PRESTO_VERSION) .
	$(eval READY_IMAGES += $(DOCKER_USER)/shell:$(HADOOP_VERSION)-$(SPARK_VERSION)-$(PRESTO_VERSION))

.PHONY: $(DOCKER_IMAGES)