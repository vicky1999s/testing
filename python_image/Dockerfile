FROM registry.access.redhat.com/ubi8/python-39

USER default

WORKDIR /app

COPY myapp.py .
COPY oc /bin/

CMD ["python3", "myapp.py"]