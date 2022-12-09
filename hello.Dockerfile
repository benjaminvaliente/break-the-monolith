FROM public.ecr.aws/bitnami/python:3.10

WORKDIR /home/server

COPY . ./

RUN pip install -r requirements.txt --quiet

EXPOSE 80

CMD [ "python3", "./hello.py" ]