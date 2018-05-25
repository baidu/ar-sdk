package com.baidu.ar.speech;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.ConcurrentLinkedQueue;

import android.util.Log;

/**
 * Created by huxiaowen on 2017/8/4.
 */
public class AudioInputStream extends InputStream {
    private static final String TAG = AudioInputStream.class.getSimpleName();

    // 存储用于识别的音频数据
    private ConcurrentLinkedQueue<ByteBuffer> mByteBufferQueue = null;
    // 回收mByteBufferQueue中已经识别并废弃的数据，以便下次使用，减少内存创建与回收
    private ConcurrentLinkedQueue<ByteBuffer> mTempByteBufferQueue = null;
    private int mFrameSize = 0;
    private int mFrameCount = 0;
    private int mBufferCount = 0;

    private static volatile boolean sReading = false;
    private static volatile boolean sStopReading = false;

    public AudioInputStream(int frameSize, int frameCount) {
        mFrameSize = frameSize;
        mFrameCount = frameCount;
        mByteBufferQueue = new ConcurrentLinkedQueue<>();
        mTempByteBufferQueue = new ConcurrentLinkedQueue<>();
    }

    @Override
    public int read() throws IOException {
        return 0;
    }

    @Override
    public synchronized int read(byte[] bytes, int offset, int length) throws IOException {
        if (!sReading) {
            sReading = true;
            sStopReading = false;
        }

        if (sStopReading) {
            Log.d(TAG, "read() sStopReading = " + sStopReading);
            throw new IOException("stop AudioInputStream by IOException");
        }

        if (mByteBufferQueue.isEmpty()) {
            return 0;
        }

        ByteBuffer byteBuffer = mByteBufferQueue.poll();
        if (byteBuffer != null) {
            byteBuffer.flip();
            if (byteBuffer.capacity() < length) {
                return 0;
            }
            System.arraycopy(byteBuffer.array(), 0, bytes, offset, length);

            if (mTempByteBufferQueue != null) {
                mTempByteBufferQueue.offer(byteBuffer);
            }
        }

        return length;
    }

    public void closeByUser() {
        Log.d(TAG, "closeByUser() sReading = " + sReading);
        if (sReading) {
            sStopReading = true;
        }
    }

    public void close() throws IOException {
        Log.d(TAG, "close() !!!");
        sReading = false;
        sStopReading = false;
        mByteBufferQueue.clear();
        mTempByteBufferQueue.clear();
        mBufferCount = 0;
    }

    public synchronized void reset() throws IOException {
        Log.d(TAG, "reset() !!!");
        sReading = false;
    }

    public synchronized void writeFrameData(final ByteBuffer newByteBuffer) {
        if (!sReading) {
            return;
        }

        try {
            ByteBuffer byteBuffer;
            if (mTempByteBufferQueue.isEmpty()) {
                if (mBufferCount < mFrameCount) {
                    byteBuffer = ByteBuffer.allocate(mFrameSize);
                    if (byteBuffer != null) {
                        mBufferCount++;
                    }
                } else {
                    byteBuffer = mByteBufferQueue.poll();
                }
            } else {
                byteBuffer = mTempByteBufferQueue.poll();
            }

            if (mByteBufferQueue != null && byteBuffer != null) {
                mByteBufferQueue.offer(byteBuffer);

                if (newByteBuffer != null && byteBuffer.capacity() >= newByteBuffer.capacity()) {
                    byteBuffer.clear();
                    byteBuffer.put(newByteBuffer);
                    newByteBuffer.flip();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}