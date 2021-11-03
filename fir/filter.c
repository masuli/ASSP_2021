#define k0 37
#define k1 109
#define k2 109
#define k3 37
#define x 128
#define SCALE 8

void fir_filter() {
	int d0 = 0;
	int d1 = 0;
	int d2 = 0;
	int d3 = 0;
	int input_sample_1;
	int input_sample_2;
	int input_sample_3;
	int input_sample_4;
	int filtered_sample_1;
	int filtered_sample_2;
	int filtered_sample_3;
	int filtered_sample_4;
	int status = 1;

	while (status > 0) {
		_TCE_FIFO_U8_STREAM_IN(0, input_sample_1, status);
		_TCE_FIFO_U8_STREAM_IN(0, input_sample_2, status);
		_TCE_FIFO_U8_STREAM_IN(0, input_sample_3, status);
		_TCE_FIFO_U8_STREAM_IN(0, input_sample_4, status);
		
		input_sample_1 -= x;
		input_sample_2 -= x;
		input_sample_3 -= x;
		input_sample_4 -= x;

		filtered_sample_1 = d1 * k0 + d2 * k1 + d3 * k2 + input_sample_1 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample_1 >> SCALE) + x);

		filtered_sample_2 = d2 * k0 + d3 * k1 + input_sample_1 * k2 + input_sample_2 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample_2 >> SCALE) + x);

		filtered_sample_3 = d3 * k0 + input_sample_1 * k1 + input_sample_2 * k2 + input_sample_3 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample_3 >> SCALE) + x);

		filtered_sample_4 = input_sample_1 * k0 + input_sample_2 * k1 + input_sample_3 * k2 + input_sample_4 * k3;
		_TCE_FIFO_U8_STREAM_OUT((filtered_sample_4 >> SCALE) + x);

		d0 = input_sample_1;
		d1 = input_sample_2;
		d2 = input_sample_3;
		d3 = input_sample_4;
	}
	_TCE_FIFO_U8_STREAM_IN(0, input_sample_1, status);
	_TCE_FIFO_U8_STREAM_IN(0, input_sample_2, status);
	_TCE_FIFO_U8_STREAM_IN(0, input_sample_3, status);
	_TCE_FIFO_U8_STREAM_IN(0, input_sample_4, status);
	
	input_sample_1 -= x;
	input_sample_2 -= x;
	input_sample_3 -= x;
	input_sample_4 -= x;

	filtered_sample_1 = d1 * k0 + d2 * k1 + d3 * k2 + input_sample_1 * k3;
	_TCE_FIFO_U8_STREAM_OUT((filtered_sample_1 >> SCALE) + x);

	filtered_sample_2 = d2 * k0 + d3 * k1 + input_sample_1 * k2 + input_sample_2 * k3;
	_TCE_FIFO_U8_STREAM_OUT((filtered_sample_2 >> SCALE) + x);

	filtered_sample_3 = d3 * k0 + input_sample_1 * k1 + input_sample_2 * k2 + input_sample_3 * k3;
	_TCE_FIFO_U8_STREAM_OUT((filtered_sample_3 >> SCALE) + x);

	filtered_sample_4 = input_sample_1 * k0 + input_sample_2 * k1 + input_sample_3 * k2 + input_sample_4 * k3;
	_TCE_FIFO_U8_STREAM_OUT((filtered_sample_4 >> SCALE) + x);
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
