#!/bin/bash

set -e

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="loadmaster-postgres"
DB_USER="loadmaster"
DB_NAME="loadmaster_db"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "💾 Starting database backup..."
echo "Date: $DATE"
echo ""

# Check if container is running
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo "❌ Error: Container $CONTAINER_NAME is not running"
    exit 1
fi

# Create backup
BACKUP_FILE="$BACKUP_DIR/loadmaster_${DATE}.sql.gz"
echo "📦 Creating backup: $BACKUP_FILE"

docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "✅ Backup created successfully!"
    
    # Get file size
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "📊 Backup size: $SIZE"
    
    # Clean up old backups (keep last 30 days)
    echo "🧹 Cleaning up old backups..."
    find "$BACKUP_DIR" -name "loadmaster_*.sql.gz" -mtime +30 -delete
    
    # Count remaining backups
    COUNT=$(find "$BACKUP_DIR" -name "loadmaster_*.sql.gz" | wc -l)
    echo "📁 Total backups: $COUNT"
    
    # Optional: Upload to S3 (uncomment if using AWS)
    # if command -v aws &> /dev/null; then
    #     echo "☁️  Uploading to S3..."
    #     aws s3 cp "$BACKUP_FILE" s3://your-backup-bucket/loadmaster/
    #     echo "✅ Uploaded to S3"
    # fi
    
    echo ""
    echo "✅ Backup complete!"
else
    echo "❌ Backup failed!"
    exit 1
fi

