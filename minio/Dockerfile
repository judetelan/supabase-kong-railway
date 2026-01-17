FROM minio/minio:latest

# MinIO requires MINIO_ROOT_USER and MINIO_ROOT_PASSWORD env vars
EXPOSE 9000 9001

# Use minio directly as entrypoint
ENTRYPOINT ["/usr/bin/minio"]
CMD ["server", "/data", "--console-address", ":9001"]
