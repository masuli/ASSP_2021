#define k0 37
#define k1 109
#define k2 109
#define k3 37
#define x 128

void fir_filter() {
	int d0 = 0;
	int d1 = 0;
	int d2 = 0;
	int d3 = 0;
	int input_sample;
	int filtered_sample;
	int status = 1;

	while (status > 0) {
		_TCE_FIFO_U8_STREAM_IN(0, input_sample, status);

		d0 = d1;
		d1 = d2;
		d2 = d3;
		d3 = input_sample - x;

		filtered_sample = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample >> 8) + x);
		_TCE_FIFO_U8_STREAM_IN(0, input_sample, status);

		d0 = d1;
		d1 = d2;
		d2 = d3;
		d3 = input_sample - x;

		filtered_sample = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample >> 8) + x);
		_TCE_FIFO_U8_STREAM_IN(0, input_sample, status);

		d0 = d1;
		d1 = d2;
		d2 = d3;
		d3 = input_sample - x;

		filtered_sample = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample >> 8) + x);
		_TCE_FIFO_U8_STREAM_IN(0, input_sample, status);

		d0 = d1;
		d1 = d2;
		d2 = d3;
		d3 = input_sample - x;

		filtered_sample = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample >> 8) + x);
	}
}

void copy_header(int size) {
	int i;
	int temp;
	int status;
	for (i = 0; i < size; i++) {
		_TCE_FIFO_U8_STREAM_IN(0, temp, status);
		_TCE_FIFO_U8_STREAM_OUT(temp);
	}
}

int main() {
	copy_header(44);
	fir_filter();
	return 0;
}
